Given('the following tutors exist:') do |table|
  table.hashes.each do |row|
    names = row['tutor_name'].to_s.strip.split
    first = names[0..-2].join(' ').presence || names.first
    last  = names.last
    
    tutor_learner = Learner.find_or_create_by!(email: "#{first.downcase}_#{last.downcase}@example.com") do |l|
      l.password   = "password123"
      l.first_name = first
      l.last_name  = last
    end
    
    Tutor.create!(
      learner:      tutor_learner,
      bio:          row['bio'],
      rating_avg:   row['rating_avg'],
      rating_count: row['rating_count'],
      subjects:     row['subjects']
    )
  end
end

Given('I am on the {string} page') do |string|
  # Add more paths as views are added/needed
  path = case string
  when "All Tutors"
    tutors_path
  end
  visit path
end

When('I press on {string}') do |string|
  click_link string
end

Then("I am on the tutor's profile page") do
  expect(page).to have_content('Name:')
end

Then('I should see {string}') do |string|
  expect(page).to have_content(string)
end

Given('I press {string}') do |string|
  click_link string
end

When('I select {string}') do |subject|
  select subject, from: 'subject_filter'
end

Then(/^I should see the following tutors: (.*)$/) do |tutors|
  tutors.split(',').map(&:strip).each do |tutor|
    expect(page).to have_content(tutor)
  end
end

Then(/^I should not see the following tutors: (.*)$/) do |tutors|
  tutors.split(',').map(&:strip).each do |tutor|
    expect(page).not_to have_content(tutor)
  end
end

Given('I do not select a subject') do
  # does not choose from dropdown
end