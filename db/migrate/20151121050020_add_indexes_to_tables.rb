class AddIndexesToTables < ActiveRecord::Migration
    def change
        add_index :answers, :question_id
        add_index :questions, :user_id
        add_index :answers, :user_id
        add_index :attachments, :question_id
    end
end
