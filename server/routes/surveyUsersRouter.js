const _ = require('lodash')
const express = require('express')
const Survey = require('../models/survey');
const User = require('../models/user');
const router = express.Router()
const auth = require('../middlewares/authorization');
const creator = require('../middlewares/creator');
const admin = require("../middlewares/admin");
const devDebugger = require('../debugger');
// @route  get api/surveyUsers
// @desc   get all users of specfic survey
// @access Private
router.get('/:sid', auth, async (req, res) => {
    try {
        const surveyId = req.params.sid;
        devDebugger(`get to api/surveyUsers/${surveyId} with: `, req.body, req.params);
        if (! await Survey.isExists(surveyId)) {
            devDebugger(`ERROR: The survey with the given id: ${surveyId} NOT FOUND.`)
            return res
                .status(404)
                .send(`The survey with the given id: ${surveyId} NOT FOUND.`);
        }

        const survey = await Survey.loadSurveyInfoById(surveyId);
        if (!survey.users) {
            devDebugger(`ERROR: The survey with the given id: ${surveyId} NOT FOUND.`)
            return res
                .status(404)
                .send(`The survey with the given id: ${surveyId} NOT FOUND.`);
        }
        devDebugger("done...", survey.users);
        res.send(survey.users);
    } catch (e) {
        devDebugger("error on posting user:", e);
        return res.status(400).send('bad connection.');
    }
})

// @route  post api/surveyUsers/:id
// @desc   post new user for survey
// @access Private, admin
router.post('/:id', [auth, admin], async (req, res) => {
    try {
        const surveyId = req.params.id;
        // email , role
        let addedUser = req.body;
        devDebugger(`post to api/surveyUsers/${surveyId} with: `, req.body, req.params);
        if (!Survey.isExists(surveyId)) {
            devDebugger(`ERROR: The survey with the given id: ${surveyId} NOT FOUND.`)
            return res
                .status(404)
                .send(`The survey with the given id: ${surveyId} NOT FOUND.`);
        }
        const survey = await Survey.loadSurveyInfoById(surveyId);
        if (!survey.users) {
            devDebugger(`ERROR: The survey with the given id: ${surveyId} NOT FOUND.`)
            return res
                .status(404)
                .send(`The survey with the given id: ${surveyId} NOT FOUND.`);
        }
        const user = await User.findByEmail(addedUser.email);
        if (!user) {
            devDebugger(`user with email: ${addedUser.email} not found`);
            return res
                .status(404)
                .send(`user with email: ${addedUser.email} not found`);
        }
        if (user.hasSurvey(surveyId)) {
            devDebugger(`ERROR: already has the survey`)
            return res
                .status(404)
                .send(`already has the survey`);
        }
        user.addSurvey(survey, addedUser.role);
        survey.addUser(user, addedUser.role);
        user.save();
        survey.save();
        res.send(user);
    } catch (e) {
        devDebugger("error on posting user:", e);
        return res.status(400).send('bad connection.');
    }
})

// @route  delete api/surveyUsers/:id
// @desc   delete some user from the survey
// @access private, admin
router.delete('/:id/:uid', [auth, creator], async (req, res) => {
    try {
        const surveyId = req.params.id;
        const userId = req.params.uid;
        devDebugger(`delete to api/surveyUsers/${surveyId}/${userId} with: `, req.body, req.params);
        if (!Survey.isExists(surveyId)) {
            devDebugger(`ERROR: The survey with the given id: ${surveyId} NOT FOUND.`)
            return res
                .status(404)
                .send(`The survey with the given id: ${surveyId} NOT FOUND.`);
        }
        const survey = await Survey.loadSurveyInfoById(surveyId);
        if (!survey) {
            devDebugger(`ERROR: The survey with the given id: ${surveyId} NOT FOUND.`)
            return res
                .status(404)
                .send(`The survey with the given id: ${surveyId} NOT FOUND.`);
        }
        if (!survey.hasUser(userId)) {
            devDebugger(`ERROR: user with id ${userId} has not any accses to the survey with id ${surveyId}`)
            return res
                .status(404)
                .send(`The user has no permission`);
        }
        const user = await User.findUserById(userId);
        if (user)
            user.deleteSurveyById(surveyId);
        survey.deleteUserById(user);
        if (user)
            user.save();
        survey.save();
        res.send(user);
    } catch (e) {
        devDebugger("error on posting user:", e);
        return res.status(400).send('bad connection.');
    }
})


module.exports = router
