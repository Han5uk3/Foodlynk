const { onRequest } = require("firebase-functions/v2/https");
const express = require("express");
const dotenv = require("dotenv");
const bodyParser = require("body-parser");
const cors = require("cors");
const AppRouter = require("./Routes/app_routes");
const { admin, db, FieldValue } = require("./firebaseConfig");  // Import Firebase config

dotenv.config();
const app = express();

app.use(bodyParser.json());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors({ origin: true }));
app.use(AppRouter);

app.listen(3000,(_)=>console.log("Server listening on 3000"));