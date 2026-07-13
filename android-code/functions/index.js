const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.createUser = functions.https.onCall(async (data, context) => {
  const { email, password, name, plate } = data;

  try {
    const userRecord = await admin.auth().createUser({
      email: email,
      password: password,
      displayName: name,
    });

    // Realtime Database’e kaydetmek istersen (isteğe bağlı)
    await admin.database().ref(`kullanicilar/${userRecord.uid}`).set({
      ad: name,
      email: email,
      plaka: plate,
    });

    return { uid: userRecord.uid };
  } catch (error) {
    throw new functions.https.HttpsError("internal", error.message);
  }
});
