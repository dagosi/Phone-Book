class Contact < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :phones

  has_many :phones, dependent: :destroy
end
