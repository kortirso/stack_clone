module VoteableController
    extend ActiveSupport::Concern

    included do
        before_action :find_object, only: [:vote_plus, :vote_minus, :devote]
    end

    def vote_plus
        vote(1)
    end

    def vote_minus
        vote(-1)
    end

    def devote
        if @vote_object.devote(current_user)
            render json: { voted_id: @vote_object.id, message: render_to_string(partial: 'shared/votes_block', locals: { voted_object: @vote_object }) }
        else
            render json: { status: :unprocessable_entity }
        end
    end

    private
    def vote(value)
        if current_user.id != @vote_object.user_id
            @vote_object.vote(value, current_user)
            render json: { voted_id: @vote_object.id, message: render_to_string(partial: 'shared/votes_block', locals: { voted_object: @vote_object }) }
        else
            render json: { status: :unprocessable_entity }
        end
    end

    def find_object
        @vote_object = controller_name.classify.constantize.find(params[:id])
    end
end