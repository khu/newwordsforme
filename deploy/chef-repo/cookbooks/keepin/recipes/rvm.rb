# include_recipe "passenger_apache2"
# include_recipe "git"  


bash "installing rvm" do
  user "ubuntu"
  code "bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)"
  not_if "which rvm | grep rvm"
end

bash "enable the rvm for the current user" do
  user "ubuntu"
  code <<-EOC
    echo  '[[ -s "/home/ubuntu/.rvm/scripts/rvm" ]] && source "/home/ubuntu/.rvm/scripts/rvm"  # This loads RVM into a shell session.' >> /home/ubuntu/.profile
    source /home/ubuntu/.profile
  EOC

  not_if "cat /home/ubuntu/.profile | grep \"This loads RVM into a shell\""
end

bash "install REE in RVM" do
  user "ubuntu"
  
  code <<-EOC
    source /home/ubuntu/.profile
    rvm install ree-1.8.7-head
  EOC
  
  not_if "rvm list | grep ree-1.8.7-head"
end

bash "make REE the default ruby" do
  user "ubuntu"
  code  <<-EOC
    source /home/ubuntu/.profile
    rvm --default ree-1.8.7-head
  EOC
  
  not_if "rvm list | grep \"=> ree-1.8.7\""
end

bash "create the gemset for the application" do
  user "ubuntu"
  code <<-EOC
     source /home/ubuntu/.profile
     rvm use --create ree-1.8.7-head@keepin
  EOC
end
