const express = require("express");
const router = express.Router();
const _ = require("lodash");
const User = require("../models/user");
const Survey = require("../models/survey");
const Response = require("../models/response");
const { getErrorMessages } = require("../models/validationSchemas");
const auth = require("../middlewares/authorization");
const creator = require("../middlewares/creator");
const roles = require("../models/roles");

// @route  Get api/surveys
// @desc   Get All Surveys
// @access Private
router.get("/", auth, async (req, res) => {
  // load user depending on the token in the auth middleware
  const user = await User.findUserById(req.user._id);
  // load that user's surveys
  const surveys = await user.getSurveysInfo();
  // surveys.reverse();
  // send the surveys
  res.send(surveys);
});

// @route  Get api/surveys/:id
// @desc   Get Survey by it id
// @access Private
router.get("/:id", [auth], async (req, res) => {
  const surveyId = req.params.id;
  //38bf2a5f-b1a8-478e-aa91-0b0d8469e103
  if (!(await Survey.isExists(surveyId))) {
    return res
      .status(404)
      .send(`The survey with the given id: ${surveyId} NOT FOUND.`);
  }
  // load the user by it's token
  const user = await User.findUserById(req.user._id);

  // check if the logged in user has this survey
  if (!user.hasSurvey(surveyId))
    return res
      .status(404)
      .send(`The survey with the given id: ${surveyId} NOT FOUND.`);

  // load the survey from the DB
  const survey = await Survey.loadSurveyToFiliingById(surveyId);

  // send the survey
  res.send(survey);
});

// @route  Get api/surveys/:id/responses
// @desc   Get All responses For Survey by surveyId
// @access Private
router.get("/:id/responses", auth, async (req, res) => {
  const surveyId = req.params.id;

  // load the user by it's token
  const user = await User.findUserById(req.user._id);

  // check if the logged in user has this survey
  if (!user.hasSurvey(surveyId))
    return res
      .status(404)
      .send(`The survey with the given id: ${surveyId} NOT FOUND.`);
  // load the responses
  const responses = await Response.loadSurveyResponsesInfo(surveyId);

  // send the responses
  res.send(responses);
});

// @route  Get api/surveys/:sid/responses/:rid
// @desc   Get response by surveyId, responseId
// @access Private
router.get("/:sid/responses/:rid", auth, async (req, res) => {
  const surveyId = req.params.sid;
  const responseId = req.params.rid;

  // load the user by it's token
  const user = await User.findUserById(req.user._id);

  // check if the logged in user has this survey
  if (!user.hasSurvey(surveyId))
    return res
      .status(404)
      .send(`The survey with the given id: ${surveyId} NOT FOUND.`);

  // load the response
  const response = await Survey.loadSurveyResponseById(surveyId, responseId);

  // check if the response exists
  if (!response) {
    return res
      .status(404)
      .send(`The response with the given id: ${responseId} NOT FOUND.`);
  }

  // send the response
  res.send(response);
});

// @route  Get api/surveys/:id/report
// @desc   Get report For Survey by surveyId
// @access Private
router.get("/:id/report", auth, async (req, res) => {
  const surveyId = req.params.id;

  // load the user by it's token
  const user = await User.findUserById(req.user._id);

  // check if the logged in user has this survey
  if (!user.hasSurvey(surveyId))
    return res
      .status(404)
      .send(`The survey with the given id: ${surveyId} NOT FOUND.`);

  // generate the report
  const report = await Survey.generatReport(surveyId);

  // send the report
  res.send(report);
});

// @route  Post api/surveys
// @desc   Post a Survey
// @access Private
router.post("/", auth, async (req, res) => {
  // Validation
  const { error } = Survey.validate(req.body);
  if (error) {
    const message = getErrorMessages(error);
    return res.status(400).send(message);
  }

  // Create survey
  const survey = new Survey({
    ...req.body
  });

  const user = await User.findUserById(req.user._id);

  // Add the user to the survey
  survey.addUser(user, roles.ROLE_CREATOR);
  user.addSurvey(survey, roles.ROLE_CREATOR);

  // Save survey to DB
  await survey.save();
  await user.save();

  res.send(_.pick(survey, ["_id", "date", "link"]));
});

// @route  Delete api/surveys/:id
// @desc   Delete a Survey by id
// @access (Admin)
router.delete("/:id", [auth, creator], async (req, res) => {
  const _id = req.params.id;
  if (!(await Survey.isExists(_id))) {
    return res
      .status(404)
      .send(`The survey with the given id: ${_id} NOT FOUND.`);
  }
  const survey = await Survey.loadSurveyToFiliingById(_id);
  if (!survey)
    return res
      .status(404)
      .send(`The survey with the given id: ${_id} NOT FOUND.`);
  // Delete survey
  survey.remove();
  res.send(`Survey with id: ${_id} have been removed.`);
});


// @route  get api/surveys/:id/responses.xlsx
// @desc   return excel file for survey responses 
// @access (Admin)
// router.get("/:id/responsesExcel", auth, async (req, res) => {
router.get("/:id/responses.xlsx", async (req, res) => {
  const surveyId = req.params.id;
  if (!(await Survey.isExists(surveyId))) {
    return res
      .status(404)
      .send(`The survey with the given id: ${surveyId} NOT FOUND.`);
  }
  const survey = await Survey.loadSurveyInfoById(surveyId);
  if (!survey)
    return res
      .status(404)
      .send(`The survey with the given id: ${surveyId} NOT FOUND.`);
  // Delete survey
  try {
    const file = await Survey.generateResponsesExcelFile(surveyId);
    file.write(`${surveyId}.${survey.title}.Responses.xlsx`, res);
  }
  catch (e) {
    console.log(e);
    res.status(400).send("bad connection try Again later");
  }
});


module.exports = router;
