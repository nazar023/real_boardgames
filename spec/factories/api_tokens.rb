FactoryBot.define do
  factory :api_token do
    user factory: :user
    token { '' }
    status { 1 }
  end
end
