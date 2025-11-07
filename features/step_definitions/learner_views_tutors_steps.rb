Given('the following tutors exist:') do |table|
  table.hashes.each do |row|
    names = row['tutor_name'].to_s.strip.split
    first = (names[0..-2].join(' ').presence || names.first)
    last  = names.last

    tutor_learner = Learner.find_or_create_by!(
      email: "#{first.downcase.gsub(/\s+/, '_')}.#{last.downcase}@example.com"
    ) do |l|
      l.password   = 'password123'
      l.first_name = first
      l.last_name  = last
    end

    tutor = Tutor.find_or_create_by!(learner: tutor_learner) do |t|
      t.bio          = row['bio']
      t.rating_avg   = row['rating_avg']
      t.rating_count = row['rating_count']
    end

    row['subjects'].to_s.split(',').map(&:strip).each do |subject_name|
      subject = Subject.find_or_create_by!(name: subject_name) do |s|
        s.code = subject_name.parameterize.upcase.first(6)
      end
      Teach.find_or_create_by!(tutor: tutor, subject: subject)
    end
  end
end

Given('I am on the "All Tutors" page') do
  visit tutors_path
end

When('I click on {string}') do |text|
  if page.has_link?(text)
    click_link text
  elsif page.has_button?(text)
    click_button text
  else
    raise "No link or button found with text: #{text}"
  end
end

When('I filter tutors by subject {string}') do |subject_name|
  visit tutors_path(subject: subject_name)
end

When('I attempt to filter tutors without selecting a subject') do
  visit tutors_path(subject: '')
end

Then(/^I should see the following tutors: (.*)$/) do |csv|
  csv.split(',').map { |s| s.strip.delete_prefix('"').delete_suffix('"') }.each do |name|
    expect(page).to have_content(name)
  end
end

Then(/^I should not see the following tutors: (.*)$/) do |csv|
  csv.split(',').map { |s| s.strip.delete_prefix('"').delete_suffix('"') }.each do |name|
    expect(page).not_to have_content(name)
  end
end