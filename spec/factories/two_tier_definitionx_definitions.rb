# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :two_tier_definitionx_definition, :class => 'TwoTierDefinitionx::Definition' do
    name "MyString"
    active false
    for_which "MyString"
    brief_note "MyText"
    last_updated_by_id 1
    ranking_index 1
  end
end
