include ActionDispatch::TestProcess
FactoryBot.define do
  factory :reward do
    name { "MyString" }
    path { "MyString" }
    file { Rack::Test::UploadedFile.new('app/assets/images/oscar.ico', 'image/png') }
  end
end
