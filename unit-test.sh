source "$HOME/.rvm/scripts/rvm"

rvm rvmrc trust
rvm rvmrc load

gem install bundle && bundle install --local
rake db:migrate 
#rake test:units

rake ci:setup:testunit test:units
