module CommentableController
    extend ActiveSupport::Concern

    included do
        before_action :find_comment_object, only: :comment_add
    end

    def comment_add
        if current_user
            @comment = @comment_object.comments.new(comment_params)
            @comment.user = current_user
            if @comment.save!
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
        @comment_object = controller_name.classify.constantize.find(params[:id])
    end

    def comment_params
        params.require(:comment).permit(:body)
    end
end