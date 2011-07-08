desc 'check in code to repository' 
task :push do
  puts "-----------cd project root directory-----------"
  sh "cd ~/work/keepin"
  puts "-----------update code to the neweset version-----------"
  sh "git pull"
  puts "-----------run rspec-----------"
  sh "rspec spec/"
  puts "-----------run cucumber-----------"
  sh "cucumber features/ -t @done"

  sh "git push"
end

task :commit do
  sh "git add ."
  
  print "Input Your Name:"
  name    = STDIN.gets.chomp
  print "Story Number:"
  number  = STDIN.gets.chomp
  print "Chek in Message:"
  message = STDIN.gets.chomp
  
  sh "git commit -m '[#{name}]##{number} - #{message}'"
end

