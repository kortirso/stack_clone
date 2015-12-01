class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :find_comment_object, only: :create

    def create
        if current_user
            @comment = @comment_object.comments.new(comment_params)
            @comment.user = current_user
            if @comment.save
                if @comment_object.kind_of?(Question)
                    PrivatePub.publish_to "/questions/#{@comment_object.id}/comments", comment: @comment.to_json
                else
                    PrivatePub.publish_to "/questions/#{@comment_object.question_id}/answers/comments", comment: @comment.to_json
                end
            end
        end
        render nothing: true
    end

    private
    def find_comment_object
        @comment_object = params[:commentable].classify.constantize.find(params[commentable_id])
    end

    def commentable_id
        (params[:commentable].singularize + '_id').to_sym
    end

    def comment_params
        params.require(:comment).permit(:body)
    end
end
