class Attendance < ApplicationRecord
  belongs_to :user, optional: true
  #validates :user_id, presence: true    #user_idに対するバリデーション
end
