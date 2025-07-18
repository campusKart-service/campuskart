import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import './widgets/message_input_widget.dart';
import './widgets/message_item_widget.dart';
import './widgets/quick_reply_widget.dart';
import './widgets/seller_profile_header_widget.dart';
import './widgets/typing_indicator_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();

  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  XFile? _capturedImage;

  bool _isTyping = false;
  bool _isRecording = false;
  bool _showEmojiPicker = false;
  bool _isCameraInitialized = false;

  List<ChatMessage> _messages = [];
  String? _currentProductId;
  String? _sellerId;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _initializeCamera();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _cameraController?.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  void _initializeData() {
    // Extract arguments from route
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _currentProductId = args['productId'] as String?;
        _sellerId = args['sellerId'] as String?;
      }
      setState(() {});
    });
  }

  Future<void> _initializeCamera() async {
    try {
      if (await _requestCameraPermission()) {
        _cameras = await availableCameras();
        if (_cameras != null && _cameras!.isNotEmpty) {
          final camera = kIsWeb
              ? _cameras!.firstWhere(
                  (c) => c.lensDirection == CameraLensDirection.front,
                  orElse: () => _cameras!.first)
              : _cameras!.firstWhere(
                  (c) => c.lensDirection == CameraLensDirection.back,
                  orElse: () => _cameras!.first);

          _cameraController = CameraController(
              camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);
          await _cameraController!.initialize();
          await _applySettings();

          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Camera initialization failed: $e');
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        try {
          await _cameraController!.setFlashMode(FlashMode.auto);
        } catch (e) {
          debugPrint('Flash mode not supported: $e');
        }
      }
    } catch (e) {
      debugPrint('Camera settings failed: $e');
    }
  }

  void _loadMessages() {
    // Mock messages for demonstration
    setState(() {
      _messages = [
        ChatMessage(
          id: '1',
          senderId: _sellerId ?? 'seller1',
          receiverId: 'buyer1',
          message: 'Hi! Is the MacBook still available?',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isFromCurrentUser: false,
          messageType: MessageType.text,
          status: MessageStatus.read,
        ),
        ChatMessage(
          id: '2',
          senderId: 'buyer1',
          receiverId: _sellerId ?? 'seller1',
          message: 'Yes, it is! Are you interested in buying it?',
          timestamp:
              DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
          isFromCurrentUser: true,
          messageType: MessageType.text,
          status: MessageStatus.read,
        ),
        ChatMessage(
          id: '3',
          senderId: _sellerId ?? 'seller1',
          receiverId: 'buyer1',
          message: 'What\'s the condition like? Any scratches or dents?',
          timestamp:
              DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
          isFromCurrentUser: false,
          messageType: MessageType.text,
          status: MessageStatus.read,
        ),
        ChatMessage(
          id: '4',
          senderId: 'buyer1',
          receiverId: _sellerId ?? 'seller1',
          message: 'It\'s in excellent condition! I can send you some photos.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          isFromCurrentUser: true,
          messageType: MessageType.text,
          status: MessageStatus.delivered,
        ),
      ];
    });
  }

  void _sendMessage(String message,
      {MessageType type = MessageType.text, String? mediaUrl}) {
    if (message.trim().isEmpty && mediaUrl == null) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'currentUser',
      receiverId: _sellerId ?? 'seller1',
      message: message.trim(),
      timestamp: DateTime.now(),
      isFromCurrentUser: true,
      messageType: type,
      status: MessageStatus.sent,
      mediaUrl: mediaUrl,
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });

    _scrollToBottom();

    // Simulate message status updates
    _updateMessageStatus(newMessage.id, MessageStatus.delivered);
    Timer(const Duration(seconds: 2), () {
      _updateMessageStatus(newMessage.id, MessageStatus.read);
    });
  }

  void _updateMessageStatus(String messageId, MessageStatus status) {
    setState(() {
      final index = _messages.indexWhere((m) => m.id == messageId);
      if (index != -1) {
        _messages[index] = _messages[index].copyWith(status: status);
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _capturePhoto() async {
    try {
      if (_cameraController != null && _cameraController!.value.isInitialized) {
        final XFile photo = await _cameraController!.takePicture();
        setState(() {
          _capturedImage = photo;
        });
        _sendMessage('Photo', type: MessageType.image, mediaUrl: photo.path);
      }
    } catch (e) {
      debugPrint('Photo capture failed: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _sendMessage('Photo', type: MessageType.image, mediaUrl: image.path);
      }
    } catch (e) {
      debugPrint('Gallery pick failed: $e');
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        if (kIsWeb) {
          await _audioRecorder.start(
              const RecordConfig(encoder: AudioEncoder.wav),
              path: 'recording.wav');
        } else {
          await _audioRecorder.start(const RecordConfig(),
              path: 'recording.wav');
        }
        setState(() {
          _isRecording = true;
        });
      }
    } catch (e) {
      debugPrint('Recording start failed: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final String? path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });
      if (path != null) {
        _sendMessage('Voice message', type: MessageType.voice, mediaUrl: path);
      }
    } catch (e) {
      debugPrint('Recording stop failed: $e');
    }
  }

  void _handleQuickReply(String template) {
    _sendMessage(template);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: SellerProfileHeaderWidget(
          sellerId: _sellerId ?? 'seller1',
          productId: _currentProductId,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show context menu
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return const TypingIndicatorWidget();
                }

                final message = _messages[index];
                final isFirstInGroup = index == 0 ||
                    _messages[index - 1].isFromCurrentUser !=
                        message.isFromCurrentUser ||
                    _messages[index - 1]
                            .timestamp
                            .difference(message.timestamp)
                            .inMinutes >
                        5;

                return MessageItemWidget(
                  message: message,
                  isFirstInGroup: isFirstInGroup,
                  onLongPress: () => _showMessageOptions(message),
                );
              },
            ),
          ),

          // Quick reply templates
          if (_currentProductId != null) ...[
            QuickReplyWidget(
              onQuickReply: _handleQuickReply,
              productId: _currentProductId!,
            ),
          ],

          // Message input
          MessageInputWidget(
            controller: _messageController,
            isRecording: _isRecording,
            onSendMessage: (message) => _sendMessage(message),
            onCapturePhoto: _capturePhoto,
            onPickImage: _pickImageFromGallery,
            onStartRecording: _startRecording,
            onStopRecording: _stopRecording,
            onToggleEmojiPicker: () {
              setState(() {
                _showEmojiPicker = !_showEmojiPicker;
              });
            },
          ),
        ],
      ),
    );
  }

  void _showMessageOptions(ChatMessage message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message.messageType == MessageType.text) ...[
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Copy text'),
                onTap: () {
                  Navigator.pop(context);
                  // Copy to clipboard
                },
              ),
            ],
            if (message.isFromCurrentUser) ...[
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete message'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _messages.removeWhere((m) => m.id == message.id);
                  });
                },
              ),
            ],
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Report inappropriate content'),
              onTap: () {
                Navigator.pop(context);
                // Report functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Data models
class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final bool isFromCurrentUser;
  final MessageType messageType;
  final MessageStatus status;
  final String? mediaUrl;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.isFromCurrentUser,
    required this.messageType,
    required this.status,
    this.mediaUrl,
  });

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? message,
    DateTime? timestamp,
    bool? isFromCurrentUser,
    MessageType? messageType,
    MessageStatus? status,
    String? mediaUrl,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isFromCurrentUser: isFromCurrentUser ?? this.isFromCurrentUser,
      messageType: messageType ?? this.messageType,
      status: status ?? this.status,
      mediaUrl: mediaUrl ?? this.mediaUrl,
    );
  }
}

enum MessageType { text, image, voice }

enum MessageStatus { sent, delivered, read }
