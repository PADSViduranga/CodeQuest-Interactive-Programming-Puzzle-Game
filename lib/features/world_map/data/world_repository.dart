import 'package:cloud_firestore/cloud_firestore.dart';

import '../../lessons/domain/lesson.dart';
import '../domain/stage.dart';

/// Reads the world (stages) and lessons from Firestore.
class WorldRepository {
  WorldRepository(this._db);

  final FirebaseFirestore _db;

  Future<List<Stage>> loadStages() async {
    final snap = await _db.collection('stages').orderBy('order').get();
    return [for (final d in snap.docs) Stage.fromMap(d.id, d.data())];
  }

  Future<Lesson?> loadLesson(String stageId) async {
    final doc = await _db.collection('lessons').doc(stageId).get();
    final data = doc.data();
    return data == null ? null : Lesson.fromMap(data);
  }
}
