class AnswersController < ApplicationController
    before_action :authenticate_user!

    def create
        @question = Question.find(params[:question_id])
        answer = @question.answers.new(answer_params)
        answer.user = current_user
        if answer.save
            redirect_to @question, notice: 'Answer save'
        else
            redirect_to @question, notice: 'Error, answer doesnot save'
        end
    end

    def destroy
        answer = Answer.find(params[:id])
        @question = answer.question
        if answer.user.id == current_user.id && answer.destroy
            redirect_to @question, notice: 'Answer delete'
        else
            redirect_to @question, notice: 'Error, answer doesnot delete'
        end
    end

    private
    def answer_params
        params.require(:answer).permit(:body, :question_id, :user_id)
    end
end
