import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wordle_clone/hit_blow_state.dart';

class HitBlowStatesNotifier extends StateNotifier<Map<String, HitBlowState>> {
  HitBlowStatesNotifier() : super({});

  Map<String, HitBlowState> queue = {};

  void clear() {
    state = {};
  }

  void doUpdate() {
    final newState = {...state};
    queue.forEach((letter, hitBlowState) {
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
    queue.clear();
    state = newState;
  }

  void addStates(Map<String, HitBlowState> newEntries) {
    queue = {...queue, ...newEntries};
  }
}

final hitBlowStatesProvider = StateNotifierProvider.autoDispose<
    HitBlowStatesNotifier,
    Map<String, HitBlowState>>((ref) => HitBlowStatesNotifier());
