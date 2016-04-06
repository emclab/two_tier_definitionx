class CreateTwoTierDefinitionxSubDefinitions < ActiveRecord::Migration
  def change
    create_table :two_tier_definitionx_sub_definitions do |t|
      t.integer :definition_id
      t.string :name
      t.boolean :active, :default => true
      t.string :brief_note
      t.integer :ranking_index
      t.timestamps
      t.string :fort_token
    end
    
    add_index :two_tier_definitionx_sub_definitions, :definition_id
    add_index :two_tier_definitionx_sub_definitions, :name
    add_index :two_tier_definitionx_sub_definitions, :active
    add_index :two_tier_definitionx_sub_definitions, :fort_token
    add_index :two_tier_definitionx_sub_definitions, :ranking_index
  end
end
