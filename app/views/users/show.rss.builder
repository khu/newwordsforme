xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Words"
    xml.description "All the words which #{@user.name} is learning"
    xml.link user_url(@user.id, :rss)
    
    def create_description(word)
      description = "#{word.word} #{word.translation} #{word.sample} "
      unless word.link == nil then  
        description += "<a href=#{word.link}>link</a>"
      end
      description += "<br>"
      description
    end    
    
    description = ""
    unless @word_list.empty? then
      updated_date = @word_list.first.updated_at.to_date 
    end
    
    for word in @word_list
      if updated_date == word.updated_at.to_date then
        description +=  create_description(word)
      else
        xml.item do
          xml.title "#{updated_date}"
          xml.description "#{description}"
        end
        description = create_description(word)
        updated_date = word.updated_at.to_date
      end 
    end
    
    unless @word_list.empty? then
      xml.item do
        xml.title "#{updated_date}"
        xml.description "#{description}"
      end
    end
  end
end

