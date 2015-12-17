class Api::V1::QuestionsController < Api::V1::BaseController
    def index
        @questions = Question.all
        respond_with @questions
    end

    def show
        @question = Question.find(params[:id])
        respond_with @question, serializer: QuestionSerializer::Question
    end
end