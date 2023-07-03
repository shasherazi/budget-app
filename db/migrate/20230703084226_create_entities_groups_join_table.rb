class CreateEntitiesGroupsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :entities, :groups do |t|
      t.index :entity_id
      t.index :group_id
    end
  end
end
