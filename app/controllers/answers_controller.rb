class AnswersController < ApplicationController
    before_action :authenticate_user!

    def create
        @question = Question.find(params[:question_id])
        @answer = @question.answers.new(answer_params)
        @answer.user = current_user
        @answer.save
    end

    def destroy
        @answer = Answer.find(params[:id])
        @answer.destroy if @answer.user_id == current_user.id
    end

    def update
        @answer = Answer.find(params[:id])
        @answer.update(answer_params) if @answer.user_id == current_user.id
    end

    def best
        @question = Question.find(params[:question_id])
        if @question.user_id == current_user.id
            Answer.find(params[:id]).set_best
        else
            @notice = 'You cant set best answer'
        end
    end

    private
    def answer_params
        params.require(:answer).permit(:body, :question_id, :user_id, :best)
    end
end
