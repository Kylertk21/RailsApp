require "test_helper"

class StudentTest < ActiveSupport::TestCase
  fixtures :students
  test "successfully insert student to db" do
    test = students(:one)
    assert test.valid?
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
end 
