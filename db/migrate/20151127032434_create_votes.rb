class CreateVotes < ActiveRecord::Migration
    def change
        create_table :votes do |t|
            t.integer :user_id
            t.integer :value, default: 0
            t.integer :voteable_id
            t.string  :voteable_type

            t.timestamps null: false
        end

        add_index :votes, :user_id
        add_index :votes, [:voteable_id, :voteable_type]
    end
end
