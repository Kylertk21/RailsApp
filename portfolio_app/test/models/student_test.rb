require "test_helper"

class StudentTest < ActiveSupport::TestCase
  include ActiveStorage::Blob::Analyzable
  fixtures :students
  test "successfully insert student to db" do
    student = students(:one)
    assert student.valid?
    assert_not_nil Student.find_by(school_email:"Test@msudenver.edu")
    end

  test "duplicate email error" do
    assert_raises ActiveRecord::RecordInvalid do
      Student.create!(last_name: "Test", school_email: "Test@msudenver.edu", major: "CS")
    end
  end
  
  test "unentered form data error" do
    assert_raises ActiveRecord::RecordInvalid do
      Student.create!(last_name:"", school_email: "", major:"")
    end
  end

  test "successfully upload profile picture" do
    student = students(:one)
    file = fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', 'profile.png'), 'image/png')
    student.image.attach(file)
    assert student.image.attached?
    assert_equal "image/png", student.image.content_type
    assert student.image.byte_size > 0
    end
end
