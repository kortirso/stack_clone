class AddIndexesToIdentities < ActiveRecord::Migration
    def change
        add_index :identities, [:provider, :uid]
    end
end
