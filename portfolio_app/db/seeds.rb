require 'faker'
require 'open-uri'

Student.find_each do |student|
  student.image.purge if student.image.attached?
end

ActiveStorage::Blob.where.missing(:attachments).find_each(&:purge)

25.times do |i|
  student = Student.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    school_email: "#{Faker::Internet.username(specifier: "#{Faker::Name.first_name.downcase}.#{Faker::Name.last_name.downcase}")}@msudenver.edu",
    grad_date: Faker::Date.between(from: '2023-01-01', to: '2024-12-30'),
    major: Student::VALID_MAJORS.sample
  )

  image_url = "https://robohash.org/#{student.first_name.gsub(' ', '')}"
  image = URI.open(image_url)
  student.image.attach(io: image, filename: "#{student.first_name}.jpg")

  if student.save
    puts "Created: #{student.first_name} #{student.last_name}"
  else 
    puts "Failed to create: #{student.errors.full_messages.join(", ")}"
  end

end

puts "Created #{Student.count} test records"
