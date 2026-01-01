/*
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import { setGlobalOptions } from "firebase-functions";
import * as logger from "firebase-functions/logger";
import { onSchedule } from "firebase-functions/v2/scheduler";
import * as admin from "firebase-admin";
import axios from "axios";

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({ maxInstances: 10 });

export const checkEthereumGasAlerts = onSchedule(
  {
    schedule: "every 5 minutes",
    timeZone: "UTC",
  },
  async () => {
    try {
      // 1️⃣ Fetch gas price from Ethereum public RPC
      const response = await axios.post("https://ethereum.publicnode.com", {
        jsonrpc: "2.0",
        method: "eth_gasPrice",
        params: [],
        id: 1,
      });

      const gasPriceWei = parseInt(response.data.result, 16);
      const gasPriceGwei = gasPriceWei / 1e9;

      logger.info(`⛽ Ethereum gas: ${gasPriceGwei} Gwei`);

      // 2️⃣ Read alerts from Firestore (no auth, MVP)
      const snapshot = await admin
        .firestore()
        .collection("gasAlerts")
        .where("enabled", "==", true)
        .get();

      if (snapshot.empty) {
        logger.info("No active gas alerts");
        return;
      }

      // 3️⃣ Evaluate alerts`
      const notifications: Promise<string>[] = [];

      snapshot.forEach((doc: any) => {
        const { condition, threshold, chain } = doc.data();

        if (chain !== "ethereum") return;

        const shouldNotify =
          condition === "below"
            ? gasPriceGwei <= threshold
            : gasPriceGwei >= threshold;

        if (shouldNotify) {
          notifications.push(
            admin.messaging().send({
              topic: "gas-alerts",
              notification: {
                title: "⛽ Gas Alert",
                body: `Ethereum gas is ${gasPriceGwei.toFixed(
                  1
                )} Gwei (${condition} ${threshold})`,
              },
            })
          );
        }
      });

      await Promise.all(notifications);
      logger.info(`✅ Sent ${notifications.length} notifications`);
    } catch (error) {
      logger.error("🔥 Gas alert function failed", error);
    }
  }
);

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });`

admin.initializeApp();
