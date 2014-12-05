# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sys_module, class: 'Authentify::SysModule'  do
    module_name "MyString"
    module_group_name "MyString"
  end
end
