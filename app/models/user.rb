class User < ActiveRecord::Base
  self.table_name = "uf_user"
  has_many :user_guests
  has_many :guests , :through => :user_guests
end
