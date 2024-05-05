import 'package:btt/model/entities/traversed_route.dart';
import 'package:btt/view/global/constants/colors.dart';
import 'package:flutter/material.dart';

class AlternativeBuses extends StatefulWidget {
  final List<String> alternativeBuses;
  const AlternativeBuses({
    super.key,
    required this.alternativeBuses
  });

  @override
  State<AlternativeBuses> createState() => _AlternativeBusesState();
}

class _AlternativeBusesState extends State<AlternativeBuses> {
  // List<String> alternativeBuses = ["ac4", "ac4","ac4"];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Alternatives:",
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10,),
        Wrap(
          spacing: 10, // spacing between items
          runSpacing: 6, // spacing between rows
          children: [
            for (int i = 0; i < widget.alternativeBuses.length; i++)...[
              if (i % 4 == 0 && i != 0)
                const SizedBox(width: double.infinity), // New line
            Container(
              width: 50,
              decoration: BoxDecoration(
                gradient: getGradient(RouteType.bus),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border.all(color: AppColors.background),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Center(
                    child: Text(
                      widget.alternativeBuses[i],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ]
        ),
        const SizedBox(height: 10,),

      ]

    );
  }
}
