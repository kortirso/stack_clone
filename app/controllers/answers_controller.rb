class AnswersController < ApplicationController
    before_action :authenticate_user!
    before_action :answer_find, only: [:destroy, :update, :best]
    before_action :question_find, only: [:create, :best]

    def create
        @answer = @question.answers.new(answer_params)
        @answer.user = current_user
        @answer.save
    end

    def destroy
        @answer.destroy if @answer.user_id == current_user.id
    end

    def update
        @answer.update(answer_params) if @answer.user_id == current_user.id
    end

    def best
        if @question.user_id == current_user.id
            @answer.set_best
        else
            @notice = 'You cant set best answer'
        end
    end

    private
    def answer_find
        @answer = Answer.find(params[:id])
    end

    def question_find
        @question = Question.find(params[:question_id])
    end

    def answer_params
        params.require(:answer).permit(:body, :question_id, :user_id, :best)
    end
end
