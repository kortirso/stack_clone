class AddSubscribeableType < ActiveRecord::Migration
    def change
        remove_index :subscribes, :subscribeable_id
        add_column :subscribes, :subscribeable_type, :string
        add_index :subscribes, [:subscribeable_id, :subscribeable_type]
    end
end
