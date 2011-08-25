rvm rvmrc trust
rvm rvmrc load

gem install bundle && bundle install --local
bundle exec rake db:migrate 
bundle exec rake test:units