# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sys_module_mapping, class: 'Authentify::SysModuleMapping'  do
    sys_module_id 1
    sys_user_group_id 1
  end
end
