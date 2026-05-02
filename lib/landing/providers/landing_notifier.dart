import 'package:fish_meat/core/constants/colors.dart';
import 'package:fish_meat/landing/model/state/landing_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class LandingNotifier extends StateNotifier<LandingState> {
  LandingNotifier()
    : super(
        LandingState(
          currentIndex: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: ConstantColors.lightClr,
          selectedFontSize: 14,
          unselectedFontSize: 12,
        ),
      );

  void changeIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }
}

final landingProvider = StateNotifierProvider<LandingNotifier, LandingState>(
  (ref) => LandingNotifier(),
);
