class AddPhotoUrlToTutors < ActiveRecord::Migration[8.0]
  def change
    add_column :tutors, :photo_url, :string
  end
end
