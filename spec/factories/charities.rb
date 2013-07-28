# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :charity do
    name "MyString"
    registered_number 1
    activities "MyText"
    image "MyString"
    url "MyString"
  end
end
