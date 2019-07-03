const Joi = require('joi')
const Question = require('./question')
const types = require('../types')
const { Questions } = require('../validationSchemas')

class SliderQuestion extends Question {
    constructor(props) {
        super(props)
        this.type = types.QUESTION_SLIDER
        this.content = {
            min: props.content.min ,
            max: props.content.max ,
            minLabel: props.content.minLabel || 'minimum',
            maxLabel: props.content.maxLabel || 'maximum',
            defaultValue: props.content.defaultValue || props.content.min || 0,
            step: props.content.step || 1 // if 1 -> there is no step
        }
    }

    static validate(sliderQuestion) {
        const result = Joi.validate(sliderQuestion, Questions.sliderQuestionSchema)
        return result
    }
}

module.exports = SliderQuestion