import 'package:flutter/material.dart';

class OnlineIndicatorWidget extends StatelessWidget {
  final double size;
  final bool isOnline;

  const OnlineIndicatorWidget({
    Key? key,
    this.size = 12,
    required this.isOnline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isOnline ? Colors.green : Colors.grey,
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.surface,
          width: 2,
        ),
      ),
    );
  }
}
