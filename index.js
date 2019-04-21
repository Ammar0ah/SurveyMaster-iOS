const { port } = require("./config");
const express = require("express");
const app = express();

app.use(express.json());

app.listen(port, () => {
  console.log(`We are live on ${port}`);
});
