class AnswersController < ApplicationController
    def new
        @answer = Answer.new
    end

    def create
        @question = Question.find(params[:question_id])
        @answer = @question.answers.new(answer_params)
        if @answer.save
            redirect_to @question
        else
            render :new
        end
    end

    private
    def answer_params
        params.require(:answer).permit(:body, :question_id)
    end
end
