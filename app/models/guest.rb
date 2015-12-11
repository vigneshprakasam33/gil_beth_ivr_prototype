class Guest < ActiveRecord::Base
  self.table_name = "uf_guest"
  has_many :user_guests
  has_many :users , :through => :user_guests
  has_many :events , :dependent => :destroy
end
