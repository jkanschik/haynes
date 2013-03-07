FactoryGirl.define do
  factory :publisher do
    id        1
    state     "default"
    name      "Normal publisher"
    label     "Label of normal publisher"
  end

  factory :user do
    name          "Real name"
    logname       "user"
    orig_password "password"
    orig_password_confirmation "password"
  end

  factory :admin, class: User do
    name          "Real name (Admin)"
    logname       "admin"
    orig_password "password"
    role          "admin"
  end
end