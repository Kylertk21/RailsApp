require "test_helper"

class StudentTest < ActiveSupport::TestCase
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
