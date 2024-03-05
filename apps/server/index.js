import express from "express";
import { createLogger } from "logger";

const app = express();

const logger = createLogger("SERVER");

app.get("/", (_req, res) => {
  logger.log("Request Received");
  res.json({ status: "healthy!" });
});

app.listen(3000, () => {
  logger.log(`Server listening on port 3000...`);
});
