FactoryGirl.define do
  factory :notification do
    subject "subject"
    content "content"
    additional_info "{a: 1}"
    read false
    state "state"
    global false
  end
end
