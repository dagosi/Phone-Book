class Phone < ActiveRecord::Base
  attr_accessible :contact, :number, :number_type
  belongs_to :contact
end
