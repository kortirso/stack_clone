class Api::V1::QuestionsController < Api::V1::BaseController
    def index
        @questions = Question.all
        respond_with @questions
    end

    def show
        @question = Question.find(params[:id])
        respond_with @question, serializer: QuestionSerializer::Question
    end

    def create
        respond_with(@question = Question.create(question_params.merge(user: current_resource_owner)))
    end

    private
    def question_params
        params.require(:question).permit(:title, :body, :user_id)
    end
end