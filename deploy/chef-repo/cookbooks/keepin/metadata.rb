maintainer       "YOUR_COMPANY_NAME"
maintainer_email "iamkaihu@gmail.com"
license          "All rights reserved"
description      "Installs/Configures keepin"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

depends "aws"
depends "chef-client"
depends "passenger_apache2"
depends "git"
depends "mysql"

