class Event < ActiveRecord::Base
  belongs_to :guest , :class_name => 'Guest' , :foreign_key => :uf_guest_id
end
