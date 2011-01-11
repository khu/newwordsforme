class User < ActiveRecord::Base
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :password, :confirmation => true
  validates :name,  :presence => true, :length   => { :maximum => 50 }
  validates :email, :presence => true, :format   => { :with => email_regex }, :uniqueness => { :case_sensitive => false }
  attr_accessor :password
  validates :password, :presence     => true,
                         :confirmation => true,
                         :length       => { :within => 6..40 }


  has_many :word
  
end
