import 'package:cloud_functions/cloud_functions.dart';

import '../domain/answer_result.dart';

/// Sends an answer to the server and returns the result.
/// The correct answer never reaches the device.
abstract class AnswerService {
  Future<AnswerResult> submitAnswer({
    required String puzzleId,
    required String sessionId,
    required String submissionId,
    required Map<String, dynamic> answer,
    required int timeTakenMs,
    required int hintsUsed,
  });
}

class CloudAnswerService implements AnswerService {
  CloudAnswerService(this._functions);

  final FirebaseFunctions _functions;

  @override
  Future<AnswerResult> submitAnswer({
    required String puzzleId,
    required String sessionId,
    required String submissionId,
    required Map<String, dynamic> answer,
    required int timeTakenMs,
    required int hintsUsed,
  }) async {
    final response = await _functions.httpsCallable('submitAnswer').call({
      'puzzleId': puzzleId,
      'sessionId': sessionId,
      'submissionId': submissionId,
      'answer': answer,
      'timeTakenMs': timeTakenMs,
      'hintsUsed': hintsUsed,
    });
    return AnswerResult.fromMap(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}
