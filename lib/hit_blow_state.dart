enum HitBlowState {
  none,
  miss,  // 正解に含まれていない
  hit,   // 正解と文字と位置が同じ
  blow,  // 正解と位置は違うが文字が同じ
}