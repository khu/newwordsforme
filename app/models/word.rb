class Word < ActiveRecord::Base
  #validates :word, :presence => true, :uniqueness => { :case_sensitive => false }
  validates :translation, :presence => true

  belongs_to :user
  has_many :word_tag_relations
  has_many :tags, :through => :word_tag_relations, :limit => 2

  def translate!
    translated = Net::HTTP.get 'api.microsofttranslator.com', '/v2/Http.svc/Translate?appId=7E707A9D2D00707BA9B5E9BD5D36967F08F570CE&from=en&to=zh-chs&text=' + word
    self.translation = />(.*)</.match(translated)[1]
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

  def add_tag_by_name(name)
    tag = Tag.find_by_name(name)
    if tag
      tags.push(tag) if ! tags.include?(tag)
    else
      tags.create!(:name => name)
    end
  end

  def tag_names
    tag_names = []

    tags.each do |tag|
      tag_names << tag.name
    end
    tag_names
  end
  
  def update_tag_by_new_name(hash)
    oldTag = tags.find_by_name(hash[:oldTag])
    tags.delete(oldTag)  if oldTag != nil
    add_tag_by_name(hash[:newTag])
  end


end