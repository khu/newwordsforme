if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
  source "$HOME/.rvm/scripts/rvm"
elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then
  source "/usr/local/rvm/scripts/rvm"
else
  printf "ERROR: An RVM installation was not found.\n"
fi

rvm rvmrc trust
rvm rvmrc load

gem install bundle && bundle install --local
rake db:migrate 
#rake test:units

rake ci:setup:testunit test:units
