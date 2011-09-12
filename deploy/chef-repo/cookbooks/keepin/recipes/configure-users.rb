execute "create keepin database" do
  command "/usr/bin/mysqladmin -u root -p root create keepin"
  not_if do    
    require 'mysql'
    m = Mysql.new("localhost", "root", "root")
    if !m.list_dbs.include?("keepin")
      # Create the database
      Chef::Log.info "Creating mysql database keepin"
      m.query("CREATE DATABASE keepin CHARACTER SET utf8")
      m.query("GRANT ALL ON keepin.* TO 'keepin'@'localhost' IDENTIFIED BY 'keepin'")
      m.reload
    end
  end
end