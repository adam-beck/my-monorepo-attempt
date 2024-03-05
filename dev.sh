#!/bin/bash

concurrently "nodemon -w ./packages -w ./apps/server ./apps/server/index.js" "nodemon -w ./packages -w ./apps/greet-service ./apps/greet-service/index.js"

