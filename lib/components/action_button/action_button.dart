import 'package:flutter/material.dart';
import 'package:sleep_timer/controllers/settings_controller.dart';

class ActionButton extends StatelessWidget {
  final String title;
  final bool isDanger;
  final void Function()? onPressed;

  const ActionButton(
      {super.key, required this.title, this.isDanger = false, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor:
              isDanger ? Colors.red[900]!.withOpacity(0.7) : Colors.transparent,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.white24),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 4),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
