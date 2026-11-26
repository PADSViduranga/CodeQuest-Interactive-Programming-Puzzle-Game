import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Run the app against the local Firebase emulators:
///   flutter run -d chrome --dart-define=USE_EMULATOR=true
const useEmulator = bool.fromEnvironment('USE_EMULATOR');

void connectEmulators() {
  if (!useEmulator) return;
  const host = 'localhost';
  FirebaseAuth.instance.useAuthEmulator(host, 9099);
  FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
  FirebaseFunctions.instance.useFunctionsEmulator(host, 5001);
}
