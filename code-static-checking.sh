# Load RVM into a shell session *as a function*

# try to load from a user install
source "$HOME/.rvm/scripts/rvm"

rvm rvmrc trust
rvm rvmrc load

gem install bundle && bundle install --local
rake metrics:all -f ./ci/metric_fu