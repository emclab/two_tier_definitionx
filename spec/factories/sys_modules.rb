# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sys_module, class: 'Authentify::SysModule'  do
    module_name "MyString"
    module_group_name "MyString"
    fort_token '123456789'
  end
end
