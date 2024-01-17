import 'package:btt/view/widgets/action/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../global/constants/text_styles.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home', style: TextStyles.large),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              MainButton(
                  text: 'Create Location',
                  onPressed: () {
                    Navigator.of(context).pushNamed('/CreateLocation');
                  }),
              16.verticalSpace,
              MainButton(
                text: 'Create Route',
                onPressed: () {
                  Navigator.of(context).pushNamed('/CreateRoute');
                },
              ),
              16.verticalSpace,
              MainButton(
                text: 'Create Bus',
                onPressed: () {
                  Navigator.of(context).pushNamed('/CreateBus');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
