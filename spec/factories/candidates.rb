FactoryBot.define do
  factory :candidate do
    user nil
    birth_date "2017-11-15"
    phone "MyString"
    collage 1
    graduation_year 1
    higher_title "MyString"
    organization_id 1
    suborganizations ""
    diploma_file "MyString"
    shorter_invitation false
    agreed_limitations false
  end
end
