import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wordle_test/hit_blow_state.dart';

class HitBlowStatesNotifier extends StateNotifier<Map<String, HitBlowState>> {
  HitBlowStatesNotifier() : super({});

  void clear() {
    state = {};
  }

  void update(Map<String, HitBlowState> newEntries) {
    final newState = {...state};
    newEntries.forEach((letter, hitBlowState) {
      switch (hitBlowState) {
        case HitBlowState.hit:
          newState[letter] = HitBlowState.hit;
          break;
        case HitBlowState.blow:
          if (newState[letter] != HitBlowState.hit) {
            newState[letter] = HitBlowState.blow;
          }
          break;
        case HitBlowState.miss:
          if (newState[letter] == null ||
              newState[letter] == HitBlowState.none) {
            newState[letter] = HitBlowState.miss;
          }
          break;
        default:
          break;
      }
    });
    state = newState;
  }
}

final hitBlowStatesProvider = StateNotifierProvider.autoDispose<
    HitBlowStatesNotifier,
    Map<String, HitBlowState>>((ref) => HitBlowStatesNotifier());
