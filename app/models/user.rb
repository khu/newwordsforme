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
  
  before_save :encrypt_password


  def has_password?(submitted_password)
      encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end


    private

      def encrypt_password
        self.encrypted_password = encrypt(password)
      end

      def encrypt(string)
        string # Only a temporary implementation!
      end
end
