import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/conversation_item_widget.dart';
import './widgets/empty_messages_widget.dart';
import './widgets/search_bar_widget.dart';

class MessagesListScreen extends StatefulWidget {
  const MessagesListScreen({Key? key}) : super(key: key);

  @override
  State<MessagesListScreen> createState() => _MessagesListScreenState();
}

class _MessagesListScreenState extends State<MessagesListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  int _currentBottomNavIndex = 3; // Messages tab is active
  List<ConversationData> _conversations = [];
  List<ConversationData> _filteredConversations = [];
  bool _isLoading = false;
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadConversations();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadConversations() {
    setState(() {
      _isLoading = true;
    });

    // Mock conversation data
    _conversations = [
      ConversationData(
        id: '1',
        participantName: 'Sarah Chen',
        participantAvatar:
            'https://images.unsplash.com/photo-1494790108755-2616b9dc5e52?w=150&h=150&fit=crop&crop=face',
        lastMessage:
            'Sure, I can meet you at the campus library tomorrow at 2 PM. Does that work for you?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        unreadCount: 2,
        isOnline: true,
        isTyping: false,
        productTitle: 'MacBook Pro 13" M2',
        productImage:
            'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=100&h=100&fit=crop',
        conversationType: ConversationType.buying,
      ),
      ConversationData(
        id: '2',
        participantName: 'Mike Rodriguez',
        participantAvatar:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        lastMessage: 'Is the calculus textbook still available?',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        unreadCount: 0,
        isOnline: false,
        isTyping: false,
        productTitle: 'Calculus Textbook Bundle',
        productImage:
            'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=100&h=100&fit=crop',
        conversationType: ConversationType.selling,
      ),
      ConversationData(
        id: '3',
        participantName: 'Emma Wilson',
        participantAvatar:
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
        lastMessage: 'Thanks for the quick response! I\'ll take it.',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        unreadCount: 1,
        isOnline: true,
        isTyping: true,
        productTitle: 'IKEA Desk & Chair Set',
        productImage:
            'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=100&h=100&fit=crop',
        conversationType: ConversationType.buying,
      ),
      ConversationData(
        id: '4',
        participantName: 'Alex Thompson',
        participantAvatar:
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
        lastMessage: 'Perfect! I\'ll bring the iPhone to the meeting spot.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 0,
        isOnline: false,
        isTyping: false,
        productTitle: 'iPhone 14 Pro - Unlocked',
        productImage:
            'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=100&h=100&fit=crop',
        conversationType: ConversationType.selling,
      ),
      ConversationData(
        id: '5',
        participantName: 'Jessica Park',
        participantAvatar:
            'https://images.unsplash.com/photo-1489424731084-a5d8b219a5bb?w=150&h=150&fit=crop&crop=face',
        lastMessage: 'Do you have any more chemistry lab equipment available?',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        unreadCount: 0,
        isOnline: true,
        isTyping: false,
        productTitle: 'Organic Chemistry Lab Kit',
        productImage:
            'https://images.unsplash.com/photo-1532187863486-abf9dbad1b69?w=100&h=100&fit=crop',
        conversationType: ConversationType.buying,
      ),
    ];

    _filteredConversations = List.from(_conversations);

    setState(() {
      _isLoading = false;
    });
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _isSearching = _searchQuery.isNotEmpty;

      if (_searchQuery.isEmpty) {
        _filteredConversations = List.from(_conversations);
      } else {
        _filteredConversations = _conversations.where((conversation) {
          return conversation.participantName
                  .toLowerCase()
                  .contains(_searchQuery) ||
              conversation.productTitle.toLowerCase().contains(_searchQuery) ||
              conversation.lastMessage.toLowerCase().contains(_searchQuery);
        }).toList();
      }
    });
  }

  Future<void> _onRefresh() async {
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(seconds: 1));
    _loadConversations();
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.searchScreen);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.productListing);
        break;
      case 3:
        // Already on Messages
        break;
      case 4:
        Navigator.pushReplacementNamed(context, AppRoutes.userProfile);
        break;
    }
  }

  void _onConversationTap(ConversationData conversation) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(
      context,
      AppRoutes.chatScreen,
      arguments: {
        'conversationId': conversation.id,
        'participantName': conversation.participantName,
        'participantAvatar': conversation.participantAvatar,
        'productTitle': conversation.productTitle,
        'productImage': conversation.productImage,
      },
    );
  }

  void _onConversationLongPress(ConversationData conversation) {
    HapticFeedback.mediumImpact();
    _showConversationOptions(conversation);
  }

  void _showConversationOptions(ConversationData conversation) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withAlpha(102),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.mark_chat_read),
              title: Text(conversation.unreadCount > 0
                  ? 'Mark as read'
                  : 'Mark as unread'),
              onTap: () {
                Navigator.pop(context);
                _toggleReadStatus(conversation);
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text('Archive conversation'),
              onTap: () {
                Navigator.pop(context);
                _archiveConversation(conversation);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_off),
              title: const Text('Mute notifications'),
              onTap: () {
                Navigator.pop(context);
                _muteConversation(conversation);
              },
            ),
            ListTile(
              leading: const Icon(Icons.report, color: Colors.red),
              title: const Text('Report user',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _reportUser(conversation);
              },
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.red),
              title: const Text('Block contact',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _blockUser(conversation);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete conversation',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteConversation(conversation);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _toggleReadStatus(ConversationData conversation) {
    setState(() {
      final index = _conversations.indexWhere((c) => c.id == conversation.id);
      if (index != -1) {
        _conversations[index] = conversation.copyWith(
          unreadCount: conversation.unreadCount > 0 ? 0 : 1,
        );
      }
    });
    _onSearchChanged(); // Update filtered list
  }

  void _archiveConversation(ConversationData conversation) {
    setState(() {
      _conversations.removeWhere((c) => c.id == conversation.id);
    });
    _onSearchChanged(); // Update filtered list
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Conversation with ${conversation.participantName} archived'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _conversations.add(conversation);
            });
            _onSearchChanged();
          },
        ),
      ),
    );
  }

  void _muteConversation(ConversationData conversation) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Notifications muted for ${conversation.participantName}'),
      ),
    );
  }

  void _reportUser(ConversationData conversation) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User ${conversation.participantName} reported'),
      ),
    );
  }

  void _blockUser(ConversationData conversation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block User'),
        content: Text(
            'Are you sure you want to block ${conversation.participantName}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _conversations.removeWhere((c) => c.id == conversation.id);
              });
              _onSearchChanged();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('User ${conversation.participantName} blocked'),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Block'),
          ),
        ],
      ),
    );
  }

  void _deleteConversation(ConversationData conversation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Conversation'),
        content: Text(
            'Are you sure you want to delete this conversation with ${conversation.participantName}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _conversations.removeWhere((c) => c.id == conversation.id);
              });
              _onSearchChanged();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Conversation with ${conversation.participantName} deleted'),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _onComposePressed() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, AppRoutes.searchScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Messages',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _onComposePressed,
            tooltip: 'Compose new message',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            SearchBarWidget(
              controller: _searchController,
              onChanged: (_) => _onSearchChanged(),
              hintText: 'Search conversations...',
            ),

            // Conversations List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredConversations.isEmpty
                      ? _isSearching
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No conversations found',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Try searching with different keywords',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                            )
                          : const EmptyMessagesWidget()
                      : RefreshIndicator(
                          key: _refreshIndicatorKey,
                          onRefresh: _onRefresh,
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(bottom: 80),
                            itemCount: _filteredConversations.length,
                            itemBuilder: (context, index) {
                              final conversation =
                                  _filteredConversations[index];
                              return ConversationItemWidget(
                                conversation: conversation,
                                onTap: () => _onConversationTap(conversation),
                                onLongPress: () =>
                                    _onConversationLongPress(conversation),
                                searchQuery: _searchQuery,
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        selectedFontSize: 10.sp,
        unselectedFontSize: 10.sp,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _currentBottomNavIndex == 0
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'search',
              color: _currentBottomNavIndex == 1
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'add_circle_outline',
              color: _currentBottomNavIndex == 2
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Sell',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'chat_bubble',
              color: _currentBottomNavIndex == 3
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person_outline',
              color: _currentBottomNavIndex == 4
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Data Models
class ConversationData {
  final String id;
  final String participantName;
  final String participantAvatar;
  final String lastMessage;
  final DateTime timestamp;
  final int unreadCount;
  final bool isOnline;
  final bool isTyping;
  final String productTitle;
  final String productImage;
  final ConversationType conversationType;

  ConversationData({
    required this.id,
    required this.participantName,
    required this.participantAvatar,
    required this.lastMessage,
    required this.timestamp,
    required this.unreadCount,
    required this.isOnline,
    required this.isTyping,
    required this.productTitle,
    required this.productImage,
    required this.conversationType,
  });

  ConversationData copyWith({
    String? id,
    String? participantName,
    String? participantAvatar,
    String? lastMessage,
    DateTime? timestamp,
    int? unreadCount,
    bool? isOnline,
    bool? isTyping,
    String? productTitle,
    String? productImage,
    ConversationType? conversationType,
  }) {
    return ConversationData(
      id: id ?? this.id,
      participantName: participantName ?? this.participantName,
      participantAvatar: participantAvatar ?? this.participantAvatar,
      lastMessage: lastMessage ?? this.lastMessage,
      timestamp: timestamp ?? this.timestamp,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
      isTyping: isTyping ?? this.isTyping,
      productTitle: productTitle ?? this.productTitle,
      productImage: productImage ?? this.productImage,
      conversationType: conversationType ?? this.conversationType,
    );
  }
}

enum ConversationType { buying, selling }
