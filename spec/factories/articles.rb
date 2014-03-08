# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do
    supplier_id 1
    name "MyString"
    order_number "MyString"
    description "MyString"
    manufacturer "MyString"
    origin "MyString"
  end
end
