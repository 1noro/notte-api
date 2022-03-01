const { json } = require("express");
const express = require("express");
const app = express();

const port = 3000;
const appName = "Notte API";

app.get('/v1/health/live', (req, res) => {
  res.json({
    "alive": true,
    "message": "The server is alive."
  });
});

app.listen(port, () => console.log(`${appName} listening on port ${port}!`));
