/// Every kind of mini-game. [wire] is the name used in Firestore and on the server.
enum GameType {
  predictOutput('predict_output'),
  fillBlank('fill_blank'),
  dragOrder('drag_order'),
  dragBuckets('drag_buckets'),
  typing('typing'),
  grid('grid'),
  fixTheBug('fix_the_bug'),
  writeCode('write_code');

  const GameType(this.wire);

  final String wire;

  static GameType fromWire(String value) => GameType.values.firstWhere(
    (t) => t.wire == value,
    orElse: () => throw ArgumentError('Unknown game type: $value'),
  );
}
