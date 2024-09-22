json.extract! student, :id, :first_name, :last_name, :school_email, :grad_date, :created_at, :major, :updated_at
json.url student_url(student, format: :json)
