import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:root/model/message.dart';
import 'package:root/model/user.dart';

class APIs {
  static late UserM me;

  static FirebaseAuth authInstance = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static User get user => authInstance.currentUser!;

  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> getFirebaseMessagingToken() async {
    await firebaseMessaging.requestPermission();
    await firebaseMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log("Push Token: $t");
      } else {
        APIs.getFirebaseMessagingToken();
      }
    });
  }

  static Future<void> sendPushNotification(UserM chatUser, String msg) async {
    try {
      final body = {
        'to': chatUser.pushToken,
        'notification': {'title': me.name, 'body': msg}
      };

      var response = await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'key=AAAAMha4TIg:APA91bGeoSvWPpqz3NHuCMBPZv27WOyCnV4AXKZvFlb8FDovOXCW_mI2-pqxV36z8d9P5740iF-Pvo6mN4pEcqt09u8QsN_HTspM8389y-FcT7hfqJklhGRtbthTFzkBaj4PEUphPYDM'
        },
        body: jsonEncode(body),
      );
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
    } catch (e) {
      log("error: $e");
    }
  }

  static Future<void> getSelfInfo() async {
    await firestore.collection("users").doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = UserM.fromJson(user.data()!);
        await getFirebaseMessagingToken();
        APIs.updateActiveStatus(true);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  static Future<bool> userExist() async {
    return (await firestore
            .collection("users")
            .doc(authInstance.currentUser!.uid)
            .get())
        .exists;
  }

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final appUser = UserM(
      id: user.uid,
      name: user.displayName,
      email: user.email,
      image: user.photoURL.toString(),
      isOnline: false,
      about: "Uygun",
      lastActive: time,
      pushToken: "",
    );
    return await firestore
        .collection("users")
        .doc(user.uid)
        .set(appUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection("users")
        .where("id", isNotEqualTo: user.uid)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      UserM chatUser) {
    return firestore
        .collection("users")
        .where("id", isEqualTo: chatUser.id)
        .snapshots();
  }

  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection("users").doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      UserM user) {
    return firestore
        .collection("chats/${getConversationId(user.id!)}/messages/")
        .snapshots();
  }

  static Future<void> sendMessage(UserM chatUser, String msg) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final MessageM message = MessageM(
        toId: chatUser.id,
        msg: msg,
        read: '',
        type: 'text',
        fromId: user.uid,
        sent: time);

    final ref = firestore
        .collection("chats/${getConversationId(chatUser.id!)}/messages/");

    await ref
        .doc(time)
        .set(message.toJson())
        .then((value) => sendPushNotification(chatUser, msg));
  }

  static Future<void> updateMessageReadStatus(MessageM msg) async {
    firestore
        .collection("chats/${getConversationId(msg.fromId!)}/messages/")
        .doc(msg.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      UserM chatUser) {
    return firestore
        .collection("chats/${getConversationId(chatUser.id!)}/messages/")
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }
}
