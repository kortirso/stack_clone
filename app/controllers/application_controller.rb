require "application_responder"

class ApplicationController < ActionController::Base
    self.responder = ApplicationResponder
    respond_to :html

    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    rescue_from CanCan::AccessDenied do |exception|
        redirect_to root_url
    end

    def search
        @objects = params[:search][:query].empty? ? nil : find_object(params[:search][:query], params[:search][:options].to_i)
        render template: 'layouts/search'
    end

    private
    def find_object(query, option)
        riddle_query = Riddle::Query.escape(query)
        case option
            when 1 then objects = ThinkingSphinx.search riddle_query
            when 2 then objects = Question.search riddle_query
            when 3 then objects = Answer.search riddle_query
            when 4 then objects = Comment.search riddle_query
            when 5 then objects = User.search riddle_query
            else objects = ThinkingSphinx.search riddle_query
        end
        objects
    end
end
