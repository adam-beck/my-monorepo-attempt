import express from "express";
import { createLogger } from "logger";

const app = express();

const logger = createLogger("GREET SERVICE");

app.get("/greeting", (_req, res) => {
  logger.log("Request Received! Hello!");
  res.json({
    hello: "world!!!",
  });
});

app.listen(3001, () => {
  logger.log("Server listening on port 3001");
});
