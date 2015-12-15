class AnswersController < ApplicationController
    include VoteableController

    before_action :authenticate_user!
    before_action :answer_find, only: [:destroy, :best]
    before_action :answer_update, only: :update
    before_action :question_find, only: [:create, :best]
    after_action :publish_answer, only: :create

    respond_to :js

    authorize_resource

    def create
        respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
    end

    def destroy
        @answer.user_id == current_user.id ? respond_with(@answer.destroy) : respond_with(@answer)
    end

    def update
        @answer.update(answer_params) if @answer.user_id == current_user.id
        respond_with @answer
    end

    def best
        @question.user_id == current_user.id ? @answer.set_best : @notice = 'You cant set best answer'
    end

    private
    def answer_find
        @answer = Answer.find(params[:id])
        @question = @answer.question
    end

    def answer_update
        @answer = Answer.find(params[:id])
        @question = @answer.question
    end

    def question_find
        @question = Question.find(params[:question_id])
    end

    def publish_answer
        PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: @answer.to_json if @answer.valid?
    end

    def answer_params
        params.require(:answer).permit(:body, :question_id, :user_id, :best, attachments_attributes: [:file, :id, :_destroy])
    end
end
