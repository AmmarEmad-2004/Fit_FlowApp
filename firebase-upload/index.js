const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");
const data = require("./workout.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function uploadPrograms() {
  try {
    for (const programType in data) {

      // muscle / strong / general
      const programRef = db.collection("programs").doc(programType);

      await programRef.set({
        name: programType,
      });

      const daysData = data[programType];

      for (const daysKey in daysData) {

        // 2_days / 3_days / 4_days
        const daysRef = programRef
          .collection("plans")
          .doc(daysKey);

        await daysRef.set({
          days: daysKey,
          workouts: daysData[daysKey],
        });

        console.log(`Uploaded ${programType} -> ${daysKey}`);
      }
    }

    console.log("🔥 All workout programs uploaded successfully!");
  } catch (error) {
    console.error(error);
  }
}

uploadPrograms();