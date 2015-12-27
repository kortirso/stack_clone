class ChangeColumnsAtSubscribe < ActiveRecord::Migration
    def change
        remove_index :subscribes, :question_id
        rename_column :subscribes, :question_id, :subscribeable_id
        add_index :subscribes, :subscribeable_id
    end
end
