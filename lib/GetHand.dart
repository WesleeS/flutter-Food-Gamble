import 'package:firedart/firedart.dart';

const apiKey = 'AIzaSyCGZnBAEn_LyS8B8RQjEOH_T_AXyNleitU'; // exposed API key moment
const projectId = 'ws-fluttercookbook';

Future GetHand() async {
  print("step 1 (start)");
  FirebaseAuth.initialize(apiKey, VolatileStore());
  Firestore.initialize(projectId); // Firestore reuses the auth client

  var auth = FirebaseAuth.instance;
  print("step 2");
  // Sign in with user credentials
  await auth.signInAnonymously();
  print("step 3");

  // Instantiate a reference to a document - this happens offline
  var ref = Firestore.instance.collection('savedHands').document('SavedMeals');
  print("step 4");

  // Get a snapshot of the document
  var document;
  try {
    document = await ref.get();
    print("step 5");
    print('snapshot: ${document['hand']}');
    // fallback list of my hnd incase the server Can't fetch. I found this to be an issue while serving
    // but working with `flutter run` on my local machine. It wiggs out if this returns with nothing,
    // for good reason, and this is an Alright fallback.'
  } catch (e) {
    print('Error getting document: $e');
    return([53069, 53083, 52847, 52948, 52954, 52840, 52782, 52846]);
  }

  auth.signOut();
  auth.close();
  print("step 6");

  // Allow some time to get the signed out event
  await Future.delayed(Duration(milliseconds: 100));

  Firestore.instance.close();
  print("step 7");

  return(document['hand']);
}
