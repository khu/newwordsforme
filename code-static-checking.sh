rvm rvmrc trust
rvm rvmrc load

gem install bundle && bundle install --local
rake metrics:all -f ./ci/metric_fu