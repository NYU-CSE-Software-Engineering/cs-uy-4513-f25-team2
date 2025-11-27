class CreateSessionAttendees < ActiveRecord::Migration[8.0]
  def change
    create_table :session_attendees do |t|
      t.references :tutor_session, null: false, foreign_key: true
      t.references :learner, null: false, foreign_key: true

      t.timestamps
    end
  end
end
