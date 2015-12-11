class UserGuest < ActiveRecord::Base
  belongs_to :user
  belongs_to :guest , class_name: 'Guest' , :foreign_key => 'guests_id'
  self.table_name = "uf_user_guest"
end
