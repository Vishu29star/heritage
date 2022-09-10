importScripts('https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js');

   /*Update with yours config*/
  const firebaseConfig = {
   apiKey: "AIzaSyBqOSZpGphYMrNCXCtg-UweC29YdSpyYQk",
   authDomain: "heritageimm-ad896.firebaseapp.com",
   projectId: "heritageimm-ad896",
   storageBucket: "heritageimm-ad896.appspot.com",
   messagingSenderId: "160852200811",
   appId: "1:160852200811:web:4f33f27c412394e320d02e",
   measurementId: "G-D2LJ1DC3MV"
 };
  firebase.initializeApp(firebaseConfig);
  const messaging = firebase.messaging();

  /*messaging.onMessage((payload) => {
  console.log('Message received. ', payload);*/
  messaging.onBackgroundMessage(function(payload) {
    console.log('Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
      body: payload.notification.body,
    };

    self.registration.showNotification(notificationTitle,
      notificationOptions);
  });