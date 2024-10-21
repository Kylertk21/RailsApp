require 'rails_helper'
 
#request specs for the Students resource focusing on HTTP requests
#request specs for the Students resource focusing on HTTP requests
RSpec.describe "Students", type: :request do

  # GET /students (index)
  describe "GET /students" do
    context "when students exist" do
    let!(:student) { Student.create!(first_name: "Aaron", last_name: "Gordon", school_email: "gordon@msudenver.edu", major: "Computer Science BS", grad_date: "2025-05-15") }

      # Test 1: Returns a successful response and displays the search form
      it "returns a successful response and displays the search form" do
        get students_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Search') # Ensure search form is rendered
      end

      # Test 2: Ensure it does NOT display students without a search
      it "does not display students until a search is performed" do
        get students_path
        expect(response.body).to_not include("Aaron")
      end
    end

    # Test 3: Handle missing records or no search criteria provided
    context "when no students exist or no search is performed" do
      it "displays a message prompting to search" do
        get students_path
        expect(response.body).to include("Please enter search criteria to find students")
      end
    end
  end

  # Search functionality
  describe "GET /students (search functionality)" do
    let!(:student1) { Student.create!(first_name: "Aaron", last_name: "Gordon", school_email: "gordon@msudenver.edu", major: "Computer Science BS", grad_date: "2025-05-15") }
    let!(:student2) { Student.create!(first_name: "Jackie", last_name: "Joyner", school_email: "joyner@msudenver.edu", major: "Data Science and Machine Learning Major", grad_date: "2026-05-15") }

    # Test 4: Search by major
    it "returns students matching the major" do
      get students_path, params: { search: { major: "Computer Science BS" } }
      expect(response.body).to include("Aaron")
      expect(response.body).to_not include("Jackie")
    end

    # Test 5: Search by expected graduation date (before)
    it "returns students graduating before the given date" do
      get students_path, params: { search: { grad_date: "2026-01-01", before_after: "before" } }
      expect(response.body).to include("Aaron")
      expect(response.body).to_not include("Jackie")
    end

    # Test 6: Search by expected graduation date (after)
    it "returns students graduating after the given date" do 
      get students_path, params: { search: { grad_date: "2026-01-01", before_after: "after" } }
      expect(response.body).to include("Jackie")
      expect(response.body).to_not include("Aaron")
    end
  end

  # POST /students (create)
  describe "POST /students" do
    context "with valid parameters" do
      # Test 7: Create a new student and ensure it redirects
      it "creates a new student and redirects" do
        expect {
          post students_path, params: { student: { first_name: "Aaron", last_name: "Gordon", school_email: "gordon@msudenver.edu", major: "Computer Science BS", grad_date: "2025-05-15" } }
        }.to change(Student, :count).by(1)

        expect(response).to have_http_status(:found)  # Expect redirect after creation
        follow_redirect!
        expect(response.body).to include("Aaron")  # Student's details in the response
      end

      # Test 8 (Student will complete this part)
      # Ensure that it returns a 201 status or check for creation success
      it "creates a new student and returns a 201 status" do 
      valid_student = { 
        first_name: "Jackie", 
        last_name: "Joyner", 
        school_email: "joyner@msudenver.edu", 
        major: "Data Science and Machine Learning Major", 
        grad_date: "2026-05-15" 
      }
        expect { 
          post students_path, params: { student: valid_student }
        }.to change(Student, :count).by(1)
        expect(response).to have_http_status(:found) # App redirects after student creation, this verifies that the student is created
        follow_redirect!
        expect(response.body).to include("Student was successfully created")
      end

    end

    context "with invalid parameters" do
      # Test 9 (Student will complete this part)
      # Ensure it does not create a student and returns a 422 status
      it "does not create student and returns 422" do 
      invalid_student = { 
        first_name: "", 
        last_name: "", 
        school_email: "", 
        major: "", 
        grad_date: "" 
      }

      expect { 
      post students_path, params: { student:invalid_student } }.to_not change(Student, :count)

    expect(response).to have_http_status(422) 
    expect(response.body).to include("7 errors prohibited this student from being saved:")
      end
    end
  end

  # GET /students/:id (show)
  describe "GET /students/:id" do
    context "when the student exists" do
      let!(:student) { Student.create!(first_name: "Aaron", last_name: "Gordon", school_email: "gordon@msudenver.edu", major: "Computer Science BS", grad_date: "2025-05-15") }

      # Test 10 (Student will complete this part)
      # Ensure it returns a successful response (200 OK)
    it "returns a successful response (200 OK)" do
      get student_path(student)
      expect(response).to have_http_status(200)
    end

      # Test 11 (Student will complete this part)
      # Ensure it includes the student's details in the response body
    it "includes student's details in response body" do
      get student_path(student)
      expect(response.body).to include("Aaron")
      expect(response.body).to include("Gordon")
      expect(response.body).to include("gordon@msudenver.edu")
      expect(response.body).to include("Computer Science BS")
      expect(response.body).to include("2025-05-15")
    end
  end

    # Test 12: Handle missing records
    context "when student doesn't exist" do
      it "returns a 404 status" do
        get "/students/9999"
      expect(response).to have_http_status(404)
      end
    end
  end

  # DELETE /students/:id (destroy)
  describe "DELETE /students/:id" do
    let!(:student) { Student.create!(first_name: "Aaron", last_name: "Gordon", school_email: "gordon@msudenver.edu", major: "Computer Science BS", grad_date: "2025-05-15") }

    # Test 13: Deletes the student and redirects
    it "deletes the student and redirects" do 
      expect { 
        delete student_path(student) }.to change(Student, :count).by(-1)

    expect(response).to have_http_status(:found)
    follow_redirect!
    expect(response.body).to include("Student was successfully deleted")
    expect(Student.exists?(student.id)).to be_falsey


    # Test 14: Returns a 404 when trying to delete a non-existent student
    it "returns a 404 status when trying to delete a non-existent student" do
      delete "/students/9999"
      expect(response).to have_http_status(:not_found)
      end
    end
  end
end
