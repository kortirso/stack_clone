class Api::V1::AnswersController < Api::V1::BaseController
    before_action :question_find, only: [:index, :create]

    def index
        @answers = @question.answers
        respond_with @answers
    end

    def show
        @answer = Answer.find(params[:id])
        respond_with @answer, serializer: AnswerSerializer::Answer
    end

    def create
        @answer = @question.answers.create(answer_params.merge(user: current_resource_owner))
        if @answer.valid?
            render nothing: true
        else
            respond_with @answer
        end
    end

    private
    def question_find
        @question = Question.find(params[:question_id])
    end

    def answer_params
        params.require(:answer).permit(:body, :question_id, :user_id, :best)
    end
end