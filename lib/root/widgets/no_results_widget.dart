import 'package:flutter/material.dart';
import 'package:majestic_rooms/core/theme/theme_context_extension.dart';

class NoResultsWidget extends StatelessWidget {
  final String message;

  const NoResultsWidget({super.key, this.message = 'No results found...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 32),
          Icon(Icons.search_off_rounded, size: 48, color: context.hintColor),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: context.hintColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
