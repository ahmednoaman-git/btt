import 'package:btt/model/entities/route.dart';
import 'package:btt/view/global/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MiniMap2 extends StatefulWidget {
  final MapRoute route;
  final double aspectRatio;

  const MiniMap2({
    super.key,
    required this.route,
    this.aspectRatio = 1.5,
  });

  @override
  State<MiniMap2> createState() => _MiniMap2State();
}

class _MiniMap2State extends State<MiniMap2> {
  final double _aspectRatio = 1.5;
  final double width = 300;
  late double height;

  @override
  void initState() {
    height = width / _aspectRatio;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30.r),
      child: Image.network(
        'https://maps.googleapis.com/maps/api/staticmap?center=${(widget.route.start.latitude + widget.route.end.latitude) / 2},${(widget.route.start.longitude + widget.route.end.longitude) / 2}&zoom=13&size=${width.toInt()}x${height.toInt()}&maptype=roadmap&markers=color:red%7Clabel:S%7C${widget.route.start.latitude},${widget.route.start.longitude}&markers=color:red%7Clabel:E%7C${widget.route.end.latitude},${widget.route.end.longitude}&key=${Constants.googleMapsApiKey}&style=element%3Ageometry%7Ccolor%3A0x242f3e&style=element%3Alabels.text.stroke%7Ccolor%3A0x242f3e&style=element%3Alabels.text.fill%7Ccolor%3A0x746855&style=feature%3Aadministrative.locality%7Celement%3Alabels.text.fill%7Ccolor%3A0xd59563&style=feature%3Apoi%7Celement%3Alabels.text.fill%7Ccolor%3A0xd59563&style=feature%3Apoi.park%7Celement%3Ageometry%7Ccolor%3A0x263c3f&style=feature%3Apoi.park%7Celement%3Alabels.text.fill%7Ccolor%3A0x6b9a76&style=feature%3Aroad%7Celement%3Ageometry%7Ccolor%3A0x38414e&style=feature%3Aroad%7Celement%3Ageometry.stroke%7Ccolor%3A0x212a37&style=feature%3Aroad%7Celement%3Alabels.text.fill%7Ccolor%3A0x9ca5b3&style=feature%3Aroad.highway%7Celement%3Ageometry%7Ccolor%3A0x746855&style=feature%3Aroad.highway%7Celement%3Ageometry.stroke%7Ccolor%3A0x1f2835&style=feature%3Aroad.highway%7Celement%3Alabels.text.fill%7Ccolor%3A0xf3d19c&style=feature%3Atransit%7Celement%3Ageometry%7Ccolor%3A0x2f3948&style=feature%3Atransit.station%7Celement%3Alabels.text.fill%7Ccolor%3A0xd59563&style=feature%3Awater%7Celement%3Ageometry%7Ccolor%3A0x17263c&style=feature%3Awater%7Celement%3Alabels.text.fill%7Ccolor%3A0x515c6d&style=feature%3Awater%7Celement%3Alabels.text.stroke%7Ccolor%3A0x17263c',
        fit: BoxFit.cover,
      ),
    );
  }
}
