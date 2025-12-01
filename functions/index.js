const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.deleteUserAccount = functions.https.onCall(async (data, context) => {
  const uid = data.uid;

  try {
    await admin.auth().deleteUser(uid);
    return { success: true };
  } catch (error) {
    return { error: error.message };
  }
});
