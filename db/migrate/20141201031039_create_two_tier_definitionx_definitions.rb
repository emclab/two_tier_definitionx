class CreateTwoTierDefinitionxDefinitions < ActiveRecord::Migration
  def change
    create_table :two_tier_definitionx_definitions do |t|
      t.string :name
      t.boolean :active, :default => true
      t.string :for_which
      t.string :brief_note
      t.integer :last_updated_by_id
      t.integer :ranking_index
      t.timestamps
      t.string :fort_token
    end
    
    add_index :two_tier_definitionx_definitions, :name
    add_index :two_tier_definitionx_definitions, :for_which
    add_index :two_tier_definitionx_definitions, :fort_token
    add_index :two_tier_definitionx_definitions, [:active, :for_which]
    add_index :two_tier_definitionx_definitions, :ranking_index
  end
end
