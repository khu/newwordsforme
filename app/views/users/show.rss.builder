xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Words"
    xml.description "All the words which #{@user.name} is learning"
    xml.link user_url(@user.id, :rss)
    
    def create_description(word)
      description = "#{word.translation}"
      unless word.link == nil then  
        description += "<a href=#{word.link}>link</a>"
      end
      return description
    end    
    
    description = ""
    unless @words.empty? then
      updated_date = @words.first.updated_at.to_date 
    end
    
    for word in @words
        xml.item do
          xml.title "#{word.word}"
          xml.description create_description(word)
          xml.pubDate "#{word.updated_at}"
          xml.category("#{word.id}", :domain => "id")  
          xml.category(word.tag_names.join(",") , :domain => "tags")  
        end
    end
    
    unless !@words.empty? then
      xml.item do
        xml.title "#{updated_date}"
        xml.description "#{description}"
      end
    end
  end
end

