Before("@listing") do 
   arden = Factory.create(:Arden)
   friday = Time.mktime(2011, 1, 21)
   thur = Time.mktime(2011, 1, 20)
   wed_last_week = Time.mktime(2011, 1, 13)
   last_month = Time.mktime(2010, 12, 23)
   last_year = Time.mktime(2009, 12, 23)
   
   arden.word << Word.new(:word =>"tomato", :translation => "xhs", :created_at => friday, :status=>0)
   arden.word << Word.new(:word =>"to", :translation => "qu", :created_at => thur, :status=>0)
   arden.word << Word.new(:word =>"last", :translation => "jintian", :created_at => wed_last_week, :status=>1)
   arden.word << Word.new(:word =>"month", :translation => "jintian", :created_at => last_month, :status=>1)
   arden.word << Word.new(:word =>"year", :translation => "jintian", :created_at => last_year, :status=>2)
   arden.save
end
