import 'package:btt/model/entities/route.dart';
import 'package:flutter/material.dart';

import 'mini_map_2.dart';

class RouteTile extends StatelessWidget {
  final MapRoute route;
  const RouteTile({
    super.key,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 1.5,
          child: SizedBox(
            width: double.infinity,
            child: MiniMap2(
              route: route,
            ),
          ),
        ),
      ],
    );
  }
}
