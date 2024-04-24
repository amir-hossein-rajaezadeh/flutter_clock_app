import 'package:flutter/material.dart';
 import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clock/cubit/app_cubit.dart';

Container buildNoAlarmWidget(BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(bottom: 42),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 30),
          child: Text(
            "No alarm has been set!",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        GestureDetector(
          onTap: () {
            context.read<AppCubit>().navigateToAlarmScreen(null, context);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(top: 24),
            child: const Padding(
              padding:
                  EdgeInsets.only(top: 12, right: 40, left: 40, bottom: 12),
              child: Text(
                "Create One",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 34,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        )
      ],
    ),
  );
}
