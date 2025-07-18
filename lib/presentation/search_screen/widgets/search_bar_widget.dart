import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onVoiceSearch;
  final VoidCallback? onBarcodeScanner;
  final List<String> suggestions;
  final Function(String) onSuggestionTap;
  final bool isListening;

  const SearchBarWidget({
    Key? key,
    required this.controller,
    this.onVoiceSearch,
    this.onBarcodeScanner,
    required this.suggestions,
    required this.onSuggestionTap,
    required this.isListening,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _showSuggestions = _focusNode.hasFocus && widget.suggestions.isNotEmpty;
    });
  }

  void _onSuggestionTapped(String suggestion) {
    widget.onSuggestionTap(suggestion);
    _focusNode.unfocus();
    setState(() {
      _showSuggestions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withAlpha(77),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  decoration: const InputDecoration(
                    hintText: 'Search products...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _showSuggestions =
                          value.isNotEmpty && widget.suggestions.isNotEmpty;
                    });
                  },
                ),
              ),

              // Voice search button
              if (widget.onVoiceSearch != null)
                IconButton(
                  icon: Icon(
                    widget.isListening ? Icons.mic : Icons.mic_none,
                    color: widget.isListening
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(153),
                  ),
                  onPressed: widget.onVoiceSearch,
                ),

              // Barcode scanner button
              if (widget.onBarcodeScanner != null)
                IconButton(
                  icon: Icon(
                    Icons.qr_code_scanner,
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(153),
                  ),
                  onPressed: widget.onBarcodeScanner,
                ),

              const SizedBox(width: 8),
            ],
          ),
        ),

        // Suggestions dropdown
        if (_showSuggestions)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withAlpha(77),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withAlpha(26),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: widget.suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = widget.suggestions[index];
                return ListTile(
                  dense: true,
                  leading: Icon(
                    Icons.search,
                    size: 20,
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(153),
                  ),
                  title: Text(
                    suggestion,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () => _onSuggestionTapped(suggestion),
                );
              },
            ),
          ),
      ],
    );
  }
}
