const express = require("express");
const app = express();
const port = process.env.PORT || 8080;

app.get("/", (req, res) => {
  res.status(200).send("Dummy App Engine Service Active (Cost Reduced)");
});

app.listen(port, () => {
  console.log(`Dummy app listening on port ${port}`);
});
