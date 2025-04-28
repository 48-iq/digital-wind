

import 'package:flutter/material.dart';

import '../../../core/components/button.dart';

class PlayerActionButtons extends StatefulWidget {
  final List<String> actionIds;
  final List<dynamic> playerActions;
  final Function(String) onActionSelected;
  final VoidCallback? onInit;

  const PlayerActionButtons({
    super.key,
    this.onInit,
    required this.actionIds,
    required this.playerActions,
    required this.onActionSelected,
  });

  @override
  State<PlayerActionButtons> createState() => _PlayerActionsButtonState();

}

class _PlayerActionsButtonState extends State<PlayerActionButtons> {

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 50), () => widget.onInit?.call());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.actionIds.map((actionId) {
        final action = widget.playerActions.firstWhere(
              (action) => action['id'] == actionId,
          orElse: () => null,
        );
        if (action == null) return Container();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Button(
            text: action['text'],
            onPressed: () => widget.onActionSelected(actionId),
            borderColor: Colors.blue,
            spaceBetweenButtons: 5,
          ),
        );
      }).toList(),
    );
  }
}