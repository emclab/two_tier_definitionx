FactoryGirl.define do
  factory :sys_log, class: 'Authentify::SysLog'  do
    log_date                '2012-2-2'
    user_name               'blabla'
    user_id                 1
    user_ip                 '1.2.3.4'
    action_logged           'create a new user in FactoryGirl'
  end
end