# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :two_tier_definitionx_sub_definition, :class => 'TwoTierDefinitionx::SubDefinition' do
    definition_id 1
    name "MyString"
    active false
    brief_note "MyString"
    ranking_index 1
  end
end
