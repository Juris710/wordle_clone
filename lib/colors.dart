import 'package:flutter/material.dart';
import 'package:wordle_test/hit_blow_state.dart';

const backgroundColorHit = Colors.green;

const backgroundColorBlow = Color(0xFFB8B023);

const backgroundColorMiss = Colors.blueGrey;

const backgroundColorNone = Colors.transparent;

Color colorFromHitBlowState(HitBlowState hitBlowState) {
  switch (hitBlowState) {
    case HitBlowState.hit:
      return backgroundColorHit;
    case HitBlowState.blow:
      return backgroundColorBlow;
    case HitBlowState.miss:
      return backgroundColorMiss;
    default:
      return backgroundColorNone;
  }
}
