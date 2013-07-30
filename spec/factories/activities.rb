# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activity do
    user_id 1
    uid "MyString"
    activity_id "MyString"
    activity_description "MyString"
    activity_updated_time "2013-07-24 12:13:14"
  end
end
