# include_recipe "passenger_apache2"
# include_recipe "git"  

bash "install RVM" do
  user "ubuntu"
  code "bash < <(curl -s https://rvm.beginrescueend.com/install/rvm) "
  not_if "rvm --version"
end

cookbook_file "/etc/profile.d/rvm.sh"
 
bash "install REE in RVM" do
  user "ubuntu"
  code "rvm install ree-1.8.7-head"
  not_if "rvm list | grep ree-1.8.7-head"
end
 
bash "make REE the default ruby" do
  user "ubuntu"
  code "rvm --default ree-1.8.7-head"
end

bash "create the gemset for the application" do
  user "ubuntu"
  code "rvm use --create ree-1.8.7-head@keepin"
end

gem_package "chef"
gem_package "bundle"
