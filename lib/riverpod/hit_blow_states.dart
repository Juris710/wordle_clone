import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wordle_test/hit_blow_state.dart';

final hitBlowStatesProvider = StateProvider((ref) => <String, HitBlowState>{});
