require "test_helper"

class StudentTest < ActiveSupport::TestCase
  include ActiveStorage::Blob::Analyzable
  fixtures :students
  
  test "successfully insert student to db" do
    student = students(:one)
    assert student.valid?
    assert_not_nil Student.find_by(school_email:"Test@msudenver.edu")
  end

  test "required fields notpresent" do
    student = students(:blank)
    assert_not student.valid?
    assert_includes student.errors[:last_name], "can't be blank"
    assert_includes student.errors[:school_email], "can't be blank"
    assert_includes student.errors[:major], "can't be blank"
  end
  
  test "max length of fields" do
    student = students(:max)
    assert_not student.valid?
    assert_includes student.errors[:last_name], "is too long (maximum is 100 characters)"
  end

  test "updated student information" do
    student = students(:one)
    assert student.update(last_name: "Updated", major: "Math")
    assert_equal "Updated", student.reload.last_name
    assert_equal "Math", student.reload.major
  end

  test "delete student" do
    student = students(:one)
    assert_difference 'Student.count', -1 do
      student.destroy
    end
  end

  test "duplicate email error" do
    assert_raises ActiveRecord::RecordInvalid do
      Student.create!(last_name: "Test", school_email: "Test@msudenver.edu", major: "CS")
    end
  end
  
  test "valid email address" do
    student = students(:one)
    assert student.valid?
  end

  test "invalid email format" do
    student = students(:two)
    assert_not student.valid?
    assert_includes student.errors[:school_email], "must be a valid MSU Denver email address"
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
