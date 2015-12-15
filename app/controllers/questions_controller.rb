class QuestionsController < ApplicationController
    include VoteableController

    before_action :authenticate_user!, except: [:index, :show]
    before_action :question_find, only: [:show, :update, :destroy]
    before_action :build_answer, only: :show
    after_action :publish_question, only: :create

    respond_to :js, only: :update

    authorize_resource

    def index
        respond_with(@questions = Question.all)
    end

    def show
        respond_with @question
    end

    def new
        respond_with(@question = Question.new)
    end

    def create
        respond_with(@question = Question.create(question_params.merge(user: current_user)))
    end

    def update
        @question.update(question_params) if @question.user.id == current_user.id
        respond_with @question
    end

    def destroy
        @question.user_id == current_user.id ? respond_with(@question.destroy) : respond_with(@question)
    end

    private
    def question_find
        @question = Question.find(params[:id])
    end

    def build_answer
        @answer = @question.answers.build
    end

    def publish_question
        PrivatePub.publish_to "/questions", question: @question.to_json if @question.valid?
    end

    def question_params
        params.require(:question).permit(:title, :body, :user_id, attachments_attributes: [:file, :id, :_destroy])
    end
end
