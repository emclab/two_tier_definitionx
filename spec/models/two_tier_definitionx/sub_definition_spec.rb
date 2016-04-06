require 'rails_helper'

module TwoTierDefinitionx
  RSpec.describe SubDefinition, type: :model do
    it "should be OK" do
      c = FactoryGirl.create(:two_tier_definitionx_sub_definition)
      expect(c).to be_valid
    end
       
    it "should reject nil name" do
      c = FactoryGirl.build(:two_tier_definitionx_sub_definition, :name => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject nil fort_token" do
      c = FactoryGirl.build(:two_tier_definitionx_sub_definition, :fort_token => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject dup name for same definition" do
      c1 = FactoryGirl.create(:two_tier_definitionx_sub_definition, :name => 'nil', :definition_id => 1)
      c = FactoryGirl.build(:two_tier_definitionx_sub_definition, :name => 'Nil', :definition_id => 1)
      expect(c).not_to be_valid
    end
  end
end
