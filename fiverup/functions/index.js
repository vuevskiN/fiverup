const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// Schedule function to run at 10:40 AM Macedonia time every day
exports.deleteExpiredJobs = functions.pubsub.schedule("40 10 * * *")  // Schedule to run at 10:40 AM Macedonia time every day
  .timeZone("Europe/Skopje")  // Set the time zone to Macedonia (CET/CEST)
  .onRun(async (context) => {
    const currentDate = new Date();
    logger.info(`Current Date (Macedonian time): ${currentDate.toISOString()}`);

    // Set the target time for checking the due date to 10:40 AM Macedonia time
    const targetHour = 10;
    const targetMinute = 40;
    const targetSecond = 0;

    // Adjust current date to 10:40 AM Macedonia time
    currentDate.setHours(targetHour, targetMinute, targetSecond, 0);

    // Log the target date for debugging
    logger.info(`Target Date for Deletion (Macedonian time): ${currentDate.toISOString()}`);

    // Fetch all jobs from Firestore
    const jobsSnapshot = await admin.firestore().collection("jobs").get();
    const batch = admin.firestore().batch();

    jobsSnapshot.forEach((doc) => {
      const job = doc.data();
      if (job.dueDate) {
        const dueDate = job.dueDate.toDate();
        // Adjust job's due date time to 10:40 AM Macedonia time (CEST/CET)
        dueDate.setHours(targetHour, targetMinute, targetSecond, 0);

        // Log the job's due date for debugging
        logger.info(`Job ID: ${doc.id}, Due Date (Macedonian time): ${dueDate.toISOString()}`);

        // If the current date is after the due date, delete the job
        if (currentDate > dueDate) {
          batch.delete(doc.ref);
        }
      }
    });

    // Commit all deletions in one batch operation
    await batch.commit();
    logger.info("Expired jobs deleted.");
  });
