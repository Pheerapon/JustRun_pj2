import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_habit_run/app/widget_support.dart';

mixin AuthenticationFacebook {
  static Future<User> signInWithFacebook(
      {@required BuildContext context}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user;

    final LoginResult loginResult = await FacebookAuth.instance.login();

    if (loginResult.status == LoginStatus.success) {
      final OAuthCredential credential =
          FacebookAuthProvider.credential(loginResult.accessToken.token);

      try {
        // Get info User logged by token into credential
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            AppWidget.customSnackBar(
              content:
                  'The account already exists with a different credential.',
            ),
          );
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            AppWidget.customSnackBar(
              content: 'Error occurred while accessing credentials. Try again.',
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          AppWidget.customSnackBar(
            content: 'Error occurred using Facebook Sign-In. Try again.',
          ),
        );
      }
    }
    return user;
  }

  static Future<void> logOut({@required BuildContext context}) async {
    try {
      await FacebookAuth.instance.logOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        AppWidget.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }
}
