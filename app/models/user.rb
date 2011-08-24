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
    user.password=user.encrypted_password #hack


    return user if user.has_password?(submitted_password)
  end
  
  def self.authenticate_with_password(id, submitted_password)
    user = find_by_id(id)
    return nil  if user.nil?
    user.password=user.encrypted_password #hack
    return user if user.has_password?(submitted_password)
  end
  
  def all(today) 
    word
  end
  def days30(today)
    word.where("created_at >= ? and created_at <= ?", today - 30, today)
  end
  def days7(today)
    word.where("created_at >= ? and created_at <= ?", today - 7, today)
  end
  def mastered(today)
    word.where("status = ?", 2)
  end
  def unfamiliar(today)
    word.where("status = ?", 1)
  end
  def notmastered(today)
    word.where("status= ?", 0)
  end
  

    private

      def encrypt_password
        self.encrypted_password = encrypt(password)
      end

      def encrypt(string)
        string # Only a temporary implementation!
      end
end
