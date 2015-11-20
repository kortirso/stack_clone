class QuestionsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]

    def index
        @questions = Question.all
    end

    def show
        @question = Question.find(params[:id])
        @answer = Answer.new
    end

    def new
        @question = Question.new
    end

    def create
        @question = Question.new(question_params)
        @question.user = current_user
        if @question.save
            redirect_to @question, notice: 'Question save'
        else
            noticer = ''
            @question.errors.full_messages.each { |message| noticer += "#{message} " }
            redirect_to questions_path, notice: "Error, question doesnot save - #{noticer}"
        end
    end

    def update
        @question = Question.find(params[:id])
        @question.update(question_params) if @question.user.id == current_user.id
    end

    def destroy
        @question = Question.find(params[:id])
        if @question.user_id == current_user.id && @question.destroy
            redirect_to questions_path, notice: 'Question delete'
        else
            redirect_to questions_path, notice: 'Error, question doesnot delete'
        end
    end

    private
    def question_params
        params.require(:question).permit(:title, :body, :user_id)
    end
end
