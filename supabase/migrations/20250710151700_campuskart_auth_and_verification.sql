-- Campus Kart Authentication and Email Verification System
-- Location: supabase/migrations/20250710151700_campuskart_auth_and_verification.sql

-- 1. Types
CREATE TYPE public.user_role AS ENUM ('admin', 'verified_student', 'student', 'moderator');
CREATE TYPE public.verification_status AS ENUM ('pending', 'verified', 'rejected');
CREATE TYPE public.campus_status AS ENUM ('active', 'inactive');

-- 2. Core Tables

-- User profiles table (intermediary between auth.users and app data)
CREATE TABLE public.user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    full_name TEXT NOT NULL,
    role public.user_role DEFAULT 'student'::public.user_role,
    is_email_verified BOOLEAN DEFAULT false,
    campus_id UUID,
    student_id TEXT,
    phone_number TEXT,
    profile_picture_url TEXT,
    verification_status public.verification_status DEFAULT 'pending'::public.verification_status,
    verification_submitted_at TIMESTAMPTZ,
    verification_completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Campus/University table
CREATE TABLE public.campuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    domain TEXT NOT NULL UNIQUE,
    location TEXT,
    status public.campus_status DEFAULT 'active'::public.campus_status,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Email verification tokens table
CREATE TABLE public.email_verification_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    token TEXT NOT NULL UNIQUE,
    expires_at TIMESTAMPTZ NOT NULL,
    verified_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Student verification documents table
CREATE TABLE public.verification_documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    document_type TEXT NOT NULL, -- 'student_id', 'enrollment_letter', etc.
    document_url TEXT NOT NULL,
    verification_status public.verification_status DEFAULT 'pending'::public.verification_status,
    reviewed_by UUID REFERENCES public.user_profiles(id),
    reviewed_at TIMESTAMPTZ,
    rejection_reason TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 3. Add foreign key constraint after campuses table is created
ALTER TABLE public.user_profiles 
ADD CONSTRAINT fk_user_profiles_campus 
FOREIGN KEY (campus_id) REFERENCES public.campuses(id) ON DELETE SET NULL;

-- 4. Essential Indexes
CREATE INDEX idx_user_profiles_email ON public.user_profiles(email);
CREATE INDEX idx_user_profiles_campus_id ON public.user_profiles(campus_id);
CREATE INDEX idx_user_profiles_role ON public.user_profiles(role);
CREATE INDEX idx_email_verification_tokens_user_id ON public.email_verification_tokens(user_id);
CREATE INDEX idx_email_verification_tokens_token ON public.email_verification_tokens(token);
CREATE INDEX idx_verification_documents_user_id ON public.verification_documents(user_id);
CREATE INDEX idx_campuses_domain ON public.campuses(domain);

-- 5. Enable RLS
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.campuses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.email_verification_tokens ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.verification_documents ENABLE ROW LEVEL SECURITY;

-- 6. Helper Functions

-- Function to check if user is admin
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.user_profiles up
    WHERE up.id = auth.uid() 
    AND up.role = 'admin'::public.user_role
)
$$;

-- Function to check if user owns profile
CREATE OR REPLACE FUNCTION public.owns_profile(profile_user_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT auth.uid() = profile_user_id
$$;

-- Function to check if user can access verification documents
CREATE OR REPLACE FUNCTION public.can_access_verification_doc(doc_user_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT auth.uid() = doc_user_id OR public.is_admin()
$$;

-- Function to check if user can access email verification tokens
CREATE OR REPLACE FUNCTION public.can_access_email_token(token_user_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT auth.uid() = token_user_id OR public.is_admin()
$$;

-- Function for automatic profile creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.user_profiles (
        id, 
        email, 
        full_name, 
        role
    )
    VALUES (
        NEW.id, 
        NEW.email, 
        COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
        CASE 
            WHEN NEW.email = 'campuskart.service@gmail.com' THEN 'admin'::public.user_role
            ELSE 'student'::public.user_role
        END
    );
    RETURN NEW;
END;
$$;

-- Function to update email verification status
CREATE OR REPLACE FUNCTION public.verify_user_email(user_uuid UUID, verification_token TEXT)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    token_valid BOOLEAN := false;
BEGIN
    -- Check if token is valid and not expired
    SELECT EXISTS (
        SELECT 1 FROM public.email_verification_tokens evt
        WHERE evt.user_id = user_uuid 
        AND evt.token = verification_token
        AND evt.expires_at > CURRENT_TIMESTAMP
        AND evt.verified_at IS NULL
    ) INTO token_valid;

    IF token_valid THEN
        -- Mark token as verified
        UPDATE public.email_verification_tokens
        SET verified_at = CURRENT_TIMESTAMP
        WHERE user_id = user_uuid AND token = verification_token;

        -- Update user profile
        UPDATE public.user_profiles
        SET 
            is_email_verified = true,
            verification_completed_at = CURRENT_TIMESTAMP,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = user_uuid;

        RETURN true;
    END IF;

    RETURN false;
END;
$$;

-- 7. Trigger for new user creation
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 8. RLS Policies

-- User profiles policies
CREATE POLICY "users_view_own_profile"
ON public.user_profiles
FOR SELECT
TO authenticated
USING (public.owns_profile(id) OR public.is_admin());

CREATE POLICY "users_update_own_profile"
ON public.user_profiles
FOR UPDATE
TO authenticated
USING (public.owns_profile(id))
WITH CHECK (public.owns_profile(id));

CREATE POLICY "admins_manage_profiles"
ON public.user_profiles
FOR ALL
TO authenticated
USING (public.is_admin())
WITH CHECK (public.is_admin());

-- Campus policies (public read access)
CREATE POLICY "public_read_campuses"
ON public.campuses
FOR SELECT
TO public
USING (status = 'active'::public.campus_status);

CREATE POLICY "admins_manage_campuses"
ON public.campuses
FOR ALL
TO authenticated
USING (public.is_admin())
WITH CHECK (public.is_admin());

-- Email verification tokens policies
CREATE POLICY "users_manage_own_tokens"
ON public.email_verification_tokens
FOR ALL
TO authenticated
USING (public.can_access_email_token(user_id))
WITH CHECK (public.can_access_email_token(user_id));

-- Verification documents policies
CREATE POLICY "users_manage_own_documents"
ON public.verification_documents
FOR ALL
TO authenticated
USING (public.can_access_verification_doc(user_id))
WITH CHECK (public.can_access_verification_doc(user_id));

-- 9. Mock Data
DO $$
DECLARE
    admin_uuid UUID := gen_random_uuid();
    student1_uuid UUID := gen_random_uuid();
    student2_uuid UUID := gen_random_uuid();
    harvard_uuid UUID := gen_random_uuid();
    stanford_uuid UUID := gen_random_uuid();
    mit_uuid UUID := gen_random_uuid();
    berkeley_uuid UUID := gen_random_uuid();
    yale_uuid UUID := gen_random_uuid();
    princeton_uuid UUID := gen_random_uuid();
    columbia_uuid UUID := gen_random_uuid();
    uchicago_uuid UUID := gen_random_uuid();
BEGIN
    -- Create campuses first
    INSERT INTO public.campuses (id, name, domain, location, status) VALUES
        (harvard_uuid, 'Harvard University', 'harvard.edu', 'Cambridge, MA', 'active'::public.campus_status),
        (stanford_uuid, 'Stanford University', 'stanford.edu', 'Stanford, CA', 'active'::public.campus_status),
        (mit_uuid, 'MIT', 'mit.edu', 'Cambridge, MA', 'active'::public.campus_status),
        (berkeley_uuid, 'University of California, Berkeley', 'berkeley.edu', 'Berkeley, CA', 'active'::public.campus_status),
        (yale_uuid, 'Yale University', 'yale.edu', 'New Haven, CT', 'active'::public.campus_status),
        (princeton_uuid, 'Princeton University', 'princeton.edu', 'Princeton, NJ', 'active'::public.campus_status),
        (columbia_uuid, 'Columbia University', 'columbia.edu', 'New York, NY', 'active'::public.campus_status),
        (uchicago_uuid, 'University of Chicago', 'uchicago.edu', 'Chicago, IL', 'active'::public.campus_status);

    -- Create auth users with required fields
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
        created_at, updated_at, raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous, confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at, email_change_token_new, email_change,
        email_change_sent_at, email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at, phone, phone_change,
        phone_change_token, phone_change_sent_at
    ) VALUES
        (admin_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'campuskart.service@gmail.com', crypt('AdminPass123!', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Campus Kart Admin"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (student1_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'john.doe@harvard.edu', crypt('StudentPass123!', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "John Doe"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (student2_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'jane.smith@stanford.edu', crypt('StudentPass123!', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Jane Smith"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null);

    -- Update user profiles with campus associations
    UPDATE public.user_profiles 
    SET 
        campus_id = harvard_uuid,
        student_id = 'HD2024001',
        is_email_verified = true,
        verification_status = 'verified'::public.verification_status,
        verification_completed_at = CURRENT_TIMESTAMP
    WHERE id = student1_uuid;

    UPDATE public.user_profiles 
    SET 
        campus_id = stanford_uuid,
        student_id = 'ST2024002',
        is_email_verified = true,
        verification_status = 'verified'::public.verification_status,
        verification_completed_at = CURRENT_TIMESTAMP
    WHERE id = student2_uuid;

    -- Create some email verification tokens for testing
    INSERT INTO public.email_verification_tokens (user_id, email, token, expires_at) VALUES
        (student1_uuid, 'john.doe@harvard.edu', 'verify_token_123', CURRENT_TIMESTAMP + INTERVAL '24 hours'),
        (student2_uuid, 'jane.smith@stanford.edu', 'verify_token_456', CURRENT_TIMESTAMP + INTERVAL '24 hours');

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Foreign key error: %', SQLERRM;
    WHEN unique_violation THEN
        RAISE NOTICE 'Unique constraint error: %', SQLERRM;
    WHEN OTHERS THEN
        RAISE NOTICE 'Unexpected error: %', SQLERRM;
END $$;

-- 10. Cleanup function for testing
CREATE OR REPLACE FUNCTION public.cleanup_test_verification_data()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    auth_user_ids_to_delete UUID[];
BEGIN
    -- Get auth user IDs first
    SELECT ARRAY_AGG(id) INTO auth_user_ids_to_delete
    FROM auth.users
    WHERE email LIKE '%@example.com' OR email LIKE '%@test.edu';

    -- Delete in dependency order (children first, then auth.users last)
    DELETE FROM public.verification_documents WHERE user_id = ANY(auth_user_ids_to_delete);
    DELETE FROM public.email_verification_tokens WHERE user_id = ANY(auth_user_ids_to_delete);
    DELETE FROM public.user_profiles WHERE id = ANY(auth_user_ids_to_delete);

    -- Delete auth.users last (after all references are removed)
    DELETE FROM auth.users WHERE id = ANY(auth_user_ids_to_delete);

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Foreign key constraint prevents deletion: %', SQLERRM;
    WHEN OTHERS THEN
        RAISE NOTICE 'Cleanup failed: %', SQLERRM;
END;
$$;