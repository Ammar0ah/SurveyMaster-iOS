"use strict";

var _config = require("./config");

var express = require("express");
var cors = require('cors');
var app = express();

app.use(express.json());
app.use(cors());

app.get('/api', function (req, res) {
  console.log('hello from api');
  res.send({ data: 'hello from api' });
});
app.listen(_config.port, function () {
  console.log("We are live on " + _config.port);
});