class Api::V1::AnswersController < Api::V1::BaseController
    def index
        @question = Question.find(params[:question_id])
        @answers = @question.answers
        respond_with @answers
    end

    def show
        @answer = Answer.find(params[:id])
        respond_with @answer, serializer: AnswerSerializer::Answer
    end
end