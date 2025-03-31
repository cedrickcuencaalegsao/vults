import 'package:flutter/material.dart';
import '../../../core/constants/constant_string.dart';

class RegistrationProgress extends StatelessWidget {
  final int currentStep;

  const RegistrationProgress({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index + 1 <= currentStep 
                ? ConstantString.white 
                : ConstantString.grey,
            border: Border.all(
              color: index + 1 <= currentStep 
                ? ConstantString.white 
                : ConstantString.grey,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}