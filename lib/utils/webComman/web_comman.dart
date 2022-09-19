/*


import 'dart:html';

class WebComman {
  static Future<bool> askWebMicrophonePermission() async {
    */
/*final perm = await html.window.navigator.permissions.query({"name": "camera"});
    if (perm.state == "denied") {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Oops! Camera access denied!"),
        backgroundColor: Colors.orangeAccent,
      ));
      return;
    }
    final stream = await html.window.navigator.getUserMedia(video: true);*//*

    final Stream =  await window.navigator.getUserMedia(audio: true) ;
    final perm = await window.navigator.permissions!.query({"name": "microphone"});
    print(perm.state);
    print(perm.toString());
    return perm.state == "granted";
  }
}*/
