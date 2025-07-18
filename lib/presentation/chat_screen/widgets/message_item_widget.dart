import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_widget.dart';
import '../chat_screen.dart';

class MessageItemWidget extends StatelessWidget {
  final ChatMessage message;
  final bool isFirstInGroup;
  final VoidCallback? onLongPress;

  const MessageItemWidget({
    Key? key,
    required this.message,
    required this.isFirstInGroup,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 4,
          top: isFirstInGroup ? 16 : 4,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!message.isFromCurrentUser) ...[
              // Sender avatar (only for first message in group)
              SizedBox(
                width: 32,
                child: isFirstInGroup
                    ? CircleAvatar(
                        radius: 16,
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        child: CustomImageWidget(
                          imageUrl:
                              'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop&crop=face',
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 8),

              // Message bubble
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isFirstInGroup ? 16 : 4),
                          topRight: const Radius.circular(16),
                          bottomLeft: const Radius.circular(16),
                          bottomRight: const Radius.circular(16),
                        ),
                      ),
                      child: _buildMessageContent(context),
                    ),
                    if (isFirstInGroup) ...[
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          DateFormat('HH:mm').format(message.timestamp),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withAlpha(153),
                                  ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ] else ...[
              // Current user messages (right-aligned)
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: Radius.circular(isFirstInGroup ? 16 : 4),
                          bottomLeft: const Radius.circular(16),
                          bottomRight: const Radius.circular(16),
                        ),
                      ),
                      child: _buildMessageContent(context, isCurrentUser: true),
                    ),
                    if (isFirstInGroup) ...[
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              DateFormat('HH:mm').format(message.timestamp),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withAlpha(153),
                                  ),
                            ),
                            const SizedBox(width: 4),
                            _buildStatusIcon(context),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context,
      {bool isCurrentUser = false}) {
    final textColor = isCurrentUser
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSurface;

    switch (message.messageType) {
      case MessageType.text:
        return Text(
          message.message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor,
              ),
        );

      case MessageType.image:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 200,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: message.mediaUrl != null
                    ? CustomImageWidget(
                        imageUrl: message.mediaUrl!,
                        width: 200,
                        height: 150,
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: Icon(
                          Icons.image,
                          size: 40,
                          color: textColor.withAlpha(128),
                        ),
                      ),
              ),
            ),
            if (message.message.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                message.message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: textColor,
                    ),
              ),
            ],
          ],
        );

      case MessageType.voice:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.mic,
              size: 20,
              color: textColor,
            ),
            const SizedBox(width: 8),
            Text(
              'Voice message',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textColor,
                  ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.play_arrow,
              size: 20,
              color: textColor,
            ),
          ],
        );
    }
  }

  Widget _buildStatusIcon(BuildContext context) {
    switch (message.status) {
      case MessageStatus.sent:
        return Icon(
          Icons.check,
          size: 16,
          color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
        );
      case MessageStatus.delivered:
        return Icon(
          Icons.done_all,
          size: 16,
          color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
        );
      case MessageStatus.read:
        return Icon(
          Icons.done_all,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        );
    }
  }
}
