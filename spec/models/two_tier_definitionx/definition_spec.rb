require 'spec_helper'

module TwoTierDefinitionx
  describe Definition do
    it "should be OK" do
      c = FactoryGirl.create(:two_tier_definitionx_definition)
      c.should be_valid
    end
       
    it "should reject nil name" do
      c = FactoryGirl.build(:two_tier_definitionx_definition, :name => nil)
      c.should_not be_valid
    end
    
    it "should reject nil for which" do
      c = FactoryGirl.build(:two_tier_definitionx_definition, :for_which => nil)
      c.should_not be_valid
    end
       
    it "should reject dup name" do
      c1 = FactoryGirl.create(:two_tier_definitionx_definition, :name => 'nil', :for_which => 'which')
      c = FactoryGirl.build(:two_tier_definitionx_definition, :name => 'Nil', :for_which => 'which')
      c.should_not be_valid
    end
  end
end
