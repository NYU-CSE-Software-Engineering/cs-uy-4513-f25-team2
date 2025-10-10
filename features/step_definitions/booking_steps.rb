Given("I am on the Tutor Catalog page") do
  visit tutors_path
  expect(page).to have_content("Tutor Catalog")
end

When('I view tutor {string}') do |name|
  # Our placeholder catalog links to /tutors/1 with anchor text "Tutor: Jane Doe"
  click_link("Tutor: #{name}")
  expect(page).to have_content("Tutor Profile")
end

When('I select an available slot starting at {string}') do |iso_start|
  # Placeholder — in a later iteration we'll render specific slot buttons by start time.
  expect(page).to have_content("Availability slots appear here")
  @chosen_start = iso_start
end

When('I confirm the booking') do
  # Placeholder button in app/views/tutors/show.html.erb
  click_button("Book selected slot")
end

Then('I should see {string}') do |text|
  expect(page).to have_content(text)
end