class Phone < ActiveRecord::Base
  attr_accessible :contact, :number, :type
  belongs_to :contact
end
