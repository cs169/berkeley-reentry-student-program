# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

r = Random.new
students = []
staffs = []
FactoryBot.create(:admin)

10.times do
  students.push FactoryBot.create(:student)
  # create 10 students and save them
end

3.times do
  staffs.push FactoryBot.create(:staff)
end

checkin_reasons = ["Peer Support", "Counseling Appointment", "Studying", "OWLs Meeting", "Other"]
40.times do
  FactoryBot.create(:checkin, reason: checkin_reasons.sample, student: students.sample,
                              time: Time.current + r.rand(-240.hours..0.hours))
end

20.times do
  FactoryBot.create(:appointment, staff: staffs.sample, student: students.sample,
                                  time: Time.current + r.rand(-240.hours..240.hours))
end

10.times do
  FactoryBot.create(:appointment, staff: staffs.sample, student: nil, time: Time.current + r.rand(1.hours..240.hours))
end

# Create sample events for the Events page
puts "Creating sample events..."

# UPCOMING EVENTS
Event.create!(
  title: "Re-entry Student Success Workshop",
  date: Date.today + 10.days,
  start_time: Time.parse("14:00"),
  end_time: Time.parse("16:00"),
  location: "Cesar Chavez Student Center, Room 103",
  description: "Join us for this comprehensive workshop designed specifically for re-entry students! We'll cover essential topics including time management strategies, campus resources, work-life-school balance, and connecting with the re-entry community. Refreshments will be provided. Bring your questions and experiences to share!"
)

Event.create!(
  title: "Financial Aid & Scholarship Information Session",
  date: Date.today + 21.days,
  start_time: Time.parse("12:00"),
  end_time: Time.parse("13:30"),
  location: "Sproul Hall - Financial Aid Office Conference Room",
  description: "Learn about financial aid opportunities specifically for re-entry and non-traditional students. Our financial aid advisors will discuss scholarship applications, grant eligibility, work-study options, and special considerations for students with families or other obligations. This session includes a Q&A portion and one-on-one mini-consultations at the end."
)

# PAST EVENTS
Event.create!(
  title: "Re-entry Student Welcome Reception",
  date: Date.today - 45.days,
  start_time: Time.parse("17:30"),
  end_time: Time.parse("19:00"),
  location: "Alumni House, Toll Room",
  description: "This welcome reception was a wonderful opportunity for new and returning re-entry students to connect with peers, faculty mentors, and program staff. The event featured inspiring talks from successful re-entry alumni, information about program resources, and plenty of time for networking. Light refreshments and appetizers were served."
)

Event.create!(
  title: "Career Pathways for Non-Traditional Students",
  date: Date.today - 14.days,
  start_time: Time.parse("15:00"),
  end_time: Time.parse("17:00"),
  location: "Career Center, Blue Room",
  description: "This interactive workshop covered strategies for leveraging your unique life and work experiences in the job market. Topics included resume building that highlights transferable skills, interview techniques for addressing career transitions, and networking strategies. Participants received individual feedback on their professional materials and connected with employers interested in hiring students with diverse backgrounds."
)

puts "Created sample events successfully!"

