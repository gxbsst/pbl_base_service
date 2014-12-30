FactoryGirl.define do
  factory :notification do
    subject "subject"
    body "body"
    additional_info "{a: 1}"
    read false
    state "state"
    global false
  end
end
