const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");
const data = require("./workout.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

// Structure: programs/{programType}/{daysCount}/day_N
// e.g.  programs/muscle/3/day_0 → { day, time, exercises:[{name,targetArea,reps}] }

async function upload() {
  let successCount = 0;
  let errorCount = 0;

  const programTypes = Object.keys(data);
  console.log(`\n🔍 Found programs: ${programTypes.join(", ")}\n`);

  for (const programType of programTypes) {
    console.log(`📦 ── ${programType.toUpperCase()} ──────────────────────────`);
    const programData = data[programType];

    for (const dayKey of Object.keys(programData)) {
      const daysCount = dayKey.replace("_days", ""); // "2","3","4","5"
      const daysArray = programData[dayKey];
      console.log(`\n  📅 ${daysCount} days/week  (${daysArray.length} training days)`);

      for (let i = 0; i < daysArray.length; i++) {
        const dayData = daysArray[i];
        const ref = db
          .collection("programs")
          .doc(programType)
          .collection(daysCount)
          .doc(`day_${i}`);

        try {
          await ref.set({
            day: dayData.day,
            time: dayData.time,
            exercises: dayData.exercises.map((ex) => ({
              name: ex.name,
              targetArea: ex.desc, // desc → targetArea (matches Flutter ExerciseModel)
              reps: ex.reps,
            })),
          });
          console.log(`    ✅  day_${i}  │  "${dayData.day}"  │  ${dayData.time} min  │  ${dayData.exercises.length} exercises`);
          successCount++;
        } catch (err) {
          console.error(`    ❌  day_${i}  │  "${dayData.day}"  │  ERROR: ${err.message}`);
          errorCount++;
        }
      }
    }
    console.log("");
  }

  console.log("=".repeat(60));
  console.log(`✅  Successfully uploaded : ${successCount} documents`);
  if (errorCount > 0) {
    console.log(`❌  Failed               : ${errorCount} documents`);
  } else {
    console.log("\n🚀  All data uploaded successfully!");
  }
}

upload().catch((err) => {
  console.error("\n💥 Fatal error:", err.message);
  process.exit(1);
});