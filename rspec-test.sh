source "$HOME/.rvm/scripts/rvm"

rvm rvmrc trust
rvm rvmrc load

gem install bundle && bundle install --local

#rspec test
rspec spec/
