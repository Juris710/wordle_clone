import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wordle_test/hit_blow_state.dart';

class HitBlowStatesNotifier extends StateNotifier<Map<String, HitBlowState>> {
  HitBlowStatesNotifier() : super({});

  void clear(){
    state = {};
  }
  void add(Map<String, HitBlowState> newEntries){
    state = {...state, ...newEntries};
  }
}

final hitBlowStatesProvider =
    StateNotifierProvider<HitBlowStatesNotifier, Map<String, HitBlowState>>(
        (ref) => HitBlowStatesNotifier());
