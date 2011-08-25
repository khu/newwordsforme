rvm rvmrc trust
rvm rvmrc load

gem install bundle && bundle install --local
rake test:functionals