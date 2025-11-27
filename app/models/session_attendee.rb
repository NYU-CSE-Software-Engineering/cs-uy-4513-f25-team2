class SessionAttendee < ApplicationRecord
  belongs_to :tutorsession
  belongs_to :learner
end
