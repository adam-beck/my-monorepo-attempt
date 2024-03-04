function createLogger(prefix = "LOG") {
  return {
    log: (message) => {
      console.log(`${prefix}: ${message}`);
    },
  };
}

export { createLogger };
