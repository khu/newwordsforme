class Word < ActiveRecord::Base 
  validates :word, :presence => true #, :uniqueness => { :case_sensitive => false }
  validates :translation, :presence => true

  belongs_to :user
  has_many :word_tag_relations
  has_many :tags, :through => :word_tag_relations, :limit => 2
  
  def translate!
    translated = Net::HTTP.get 'ajax.googleapis.com', '/ajax/services/language/translate?v=1.0&q='+ word + '&langpair=en|zh-CN'
    j = ActiveSupport::JSON
    encoded = j.decode(translated)
    self.translation = encoded["responseData"]["translatedText"]    
  end
  
  def self.create(hash)
      words = hash[:word].split("@")
      return Word.new(hash) if words.length == 1

      hash[:word] = words[0] 
      is_url = (words[1]  =~ /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix)
      hash[:link] = words[1]   if is_url
      hash[:sample] = words[1] unless is_url
      Word.new(hash)
  end 
end