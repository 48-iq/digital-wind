import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/components/button.dart';

class PlayerActionButtons extends StatelessWidget {
  final List<String> actionIds;
  final List<dynamic> playerActions;
  final Function(String) onActionSelected;

  const PlayerActionButtons({
    super.key,
    required this.actionIds,
    required this.playerActions,
    required this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: actionIds.map((actionId) {
        final action = playerActions.firstWhere(
              (action) => action['id'] == actionId,
          orElse: () => null,
        );
        if (action == null) return Container();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Button(
            text: action['text'],
            onPressed: () => onActionSelected(actionId),
            borderColor: Colors.blue,
            spaceBetweenButtons: 5,
          ),
        );
      }).toList(),
    );
  }
}