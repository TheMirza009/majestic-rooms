import 'package:flutter/material.dart';

class NoResultsWidget extends StatelessWidget {
  final String message;

  const NoResultsWidget({
    super.key,
    this.message = 'No results found...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 32),
          const Icon(
            Icons.search_off_rounded,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
