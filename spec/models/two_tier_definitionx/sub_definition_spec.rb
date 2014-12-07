require 'spec_helper'

module TwoTierDefinitionx
  describe SubDefinition do
    it "should be OK" do
      c = FactoryGirl.create(:two_tier_definitionx_sub_definition)
      c.should be_valid
    end
       
    it "should reject nil name" do
      c = FactoryGirl.build(:two_tier_definitionx_sub_definition, :name => nil)
      c.should_not be_valid
    end
    
    it "should reject dup name for same definition" do
      c1 = FactoryGirl.create(:two_tier_definitionx_sub_definition, :name => 'nil', :definition_id => 1)
      c = FactoryGirl.build(:two_tier_definitionx_sub_definition, :name => 'Nil', :definition_id => 1)
      c.should_not be_valid
    end
  end
end
