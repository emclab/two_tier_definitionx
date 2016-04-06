require 'rails_helper'

module TwoTierDefinitionx
  RSpec.describe Definition, type: :model do
    it "should be OK" do
      c = FactoryGirl.create(:two_tier_definitionx_definition)
      expect(c).to be_valid
    end
       
    it "should reject nil name" do
      c = FactoryGirl.build(:two_tier_definitionx_definition, :name => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject nil fort_token" do
      c = FactoryGirl.build(:two_tier_definitionx_definition, :fort_token => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject nil for which" do
      c = FactoryGirl.build(:two_tier_definitionx_definition, :for_which => nil)
      expect(c).not_to be_valid
    end
       
    it "should reject dup name" do
      c1 = FactoryGirl.create(:two_tier_definitionx_definition, :name => 'nil', :for_which => 'which')
      c = FactoryGirl.build(:two_tier_definitionx_definition, :name => 'Nil', :for_which => 'which')
      expect(c).not_to be_valid
    end
  end
end
