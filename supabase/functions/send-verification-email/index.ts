import { serve } from "https://deno.land/std@0.192.0/http/server.ts";

serve(async (req) => {
  // ✅ CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", {
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, OPTIONS",
        "Access-Control-Allow-Headers": "Content-Type, Authorization"
      }
    });
  }

  try {
    const { email, token, fullName } = await req.json();

    // Prepare email content
    const emailContent = {
      from: "onboarding@resend.dev",
      to: [email],
      subject: "Verify Your Email - Campus Kart",
      html: `
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Verify Your Email</title>
        </head>
        <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px;">
          <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 40px 20px; text-align: center; border-radius: 10px 10px 0 0;">
            <h1 style="color: white; margin: 0; font-size: 28px;">Welcome to Campus Kart!</h1>
            <p style="color: white; margin: 10px 0 0 0; font-size: 16px;">Your campus marketplace community</p>
          </div>
          
          <div style="background: #f9f9f9; padding: 40px 20px; border-radius: 0 0 10px 10px;">
            <h2 style="color: #333; margin-bottom: 20px;">Hi ${fullName || 'there'}!</h2>
            
            <p style="margin-bottom: 20px;">Thank you for joining Campus Kart! To complete your registration and start exploring your campus marketplace, please verify your email address.</p>
            
            <div style="background: white; padding: 30px; border-radius: 8px; margin: 30px 0; text-align: center; border-left: 4px solid #667eea;">
              <h3 style="margin: 0 0 15px 0; color: #333;">Your Verification Code</h3>
              <div style="font-size: 32px; font-weight: bold; letter-spacing: 8px; color: #667eea; font-family: 'Courier New', monospace; background: #f0f0f0; padding: 15px; border-radius: 5px; margin: 15px 0;">
                ${token}
              </div>
              <p style="margin: 15px 0 0 0; color: #666; font-size: 14px;">Enter this code in the app to verify your email</p>
            </div>
            
            <div style="background: #fff3cd; border: 1px solid #ffeaa7; border-radius: 5px; padding: 15px; margin: 20px 0;">
              <p style="margin: 0; color: #856404;"><strong>⏰ Important:</strong> This verification code will expire in 24 hours for security reasons.</p>
            </div>
            
            <h3 style="color: #333; margin-top: 30px;">What you can do on Campus Kart:</h3>
            <ul style="color: #666; padding-left: 20px;">
              <li>Buy and sell items within your campus community</li>
              <li>Connect with verified students and faculty</li>
              <li>Find textbooks, electronics, furniture, and more</li>
              <li>Post your own items for sale</li>
            </ul>
            
            <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #ddd; text-align: center;">
              <p style="color: #666; font-size: 14px; margin: 0;">
                If you did not create an account with Campus Kart, please ignore this email.
              </p>
              <p style="color: #666; font-size: 12px; margin: 10px 0 0 0;">
                © 2025 Campus Kart. All rights reserved.
              </p>
            </div>
          </div>
        </body>
        </html>
      `
    };

    // Send email using Resend API
    const RESEND_API_KEY = Deno.env.get('RESEND_API_KEY');
    
    const response = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${RESEND_API_KEY}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(emailContent)
    });

    if (!response.ok) {
      throw new Error(`Failed to send email: ${response.statusText}`);
    }

    const result = await response.json();

    return new Response(JSON.stringify({
      success: true,
      message: 'Verification email sent successfully',
      emailId: result.id
    }), {
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
      }
    });
  } catch (error) {
    return new Response(JSON.stringify({
      error: error.message
    }), {
      status: 500,
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
      }
    });
  }
});