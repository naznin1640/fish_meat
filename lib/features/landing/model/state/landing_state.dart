import 'package:flutter/material.dart';

class LandingState {
  final int? currentIndex;
  final Color? unselectedItemColor;
  final Color? selectedItemColor;
  final double? selectedFontSize;
  final double? unselectedFontSize;

  LandingState({
    this.currentIndex,
    this.unselectedItemColor,
    this.selectedItemColor,
    this.selectedFontSize,
    this.unselectedFontSize
  });

  LandingState copyWith({
  final int? currentIndex,
  final Color? unselectedItemColor,
  final Color? selectedItemColor,
  final double? selectedFontSize,
  final double? unselectedFontSize
  }){
    return LandingState(
      currentIndex: currentIndex ?? this.currentIndex,
      unselectedItemColor: unselectedItemColor ?? this.unselectedItemColor,
      selectedItemColor: selectedItemColor ?? this.selectedItemColor,
      selectedFontSize: selectedFontSize ?? this.selectedFontSize,
      unselectedFontSize: unselectedFontSize ?? this.unselectedFontSize
    );
  } 
  }
