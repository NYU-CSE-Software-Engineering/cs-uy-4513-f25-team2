class CreateTutors < ActiveRecord::Migration[8.0]
  def change
    create_table :tutors do |t|
      t.text :bio
      t.decimal :rating_avg, precision: 3, scale: 2
      t.integer :rating_count
      t.references :learner, null: false, foreign_key: true

      t.timestamps
    end
  end
end
