const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");
const data = require("./workout.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function upload() {
  const batch = db.batch();

  Object.keys(data).forEach((key) => {
    const ref = db.collection("programs").doc(key);
    batch.set(ref, data[key]);
  });

  await batch.commit();

  console.log("Uploaded successfully 🚀");
}

upload();