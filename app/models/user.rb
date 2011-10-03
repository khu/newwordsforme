class User < ActiveRecord::Base
  acts_as_authentic
  has_many :word
  
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
end
