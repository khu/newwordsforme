# By using the symbol ':user', we get Factory Girl to simulate the User model.

Factory.define :user do |user|
  user.name                  "Michael Hartl"
  user.email                 "mhartl@example.com"
  user.crypted_password      "a7944c46edb15a444ee1facd57fb23cf7d675bf3634e0bd5728d9866bbd8f5154829981e0af0c5b50e2f5534484d8a398363fcd185c3737844e424dd81196907"
  user.password              "123456" 
  user.password_confirmation "123456"
  user.password_salt         "foobar"
end

Factory.define :Admin, :class => User do |u|
  u.name                  "Adam"
  u.email                 "adam@gmail.com"
  u.crypted_password      "a7944c46edb15a444ee1facd57fb23cf7d675bf3634e0bd5728d9866bbd8f5154829981e0af0c5b50e2f5534484d8a398363fcd185c3737844e424dd81196907"
  u.password              "123456" 
  u.password_confirmation "123456"
  u.password_salt         "foobar"
end
  
Factory.define :Figo, :class => User do |u|
  u.name                  "Figo"
  u.email                 "figo@gmail.com"
  u.crypted_password      "a7944c46edb15a444ee1facd57fb23cf7d675bf3634e0bd5728d9866bbd8f5154829981e0af0c5b50e2f5534484d8a398363fcd185c3737844e424dd81196907"
end

arden = Factory.define :Arden, :class => User do |u|
  u.name                  "Arden"
  u.email                 "arden@gmail.com"
  u.crypted_password      "a7944c46edb15a444ee1facd57fb23cf7d675bf3634e0bd5728d9866bbd8f5154829981e0af0c5b50e2f5534484d8a398363fcd185c3737844e424dd81196907"
end

Factory.define :Unice, :class => User do |u|
  u.name                  "Unice"
  u.email                 "unice@gmail.com"
  u.crypted_password      "a7944c46edb15a444ee1facd57fb23cf7d675bf3634e0bd5728d9866bbd8f5154829981e0af0c5b50e2f5534484d8a398363fcd185c3737844e424dd81196907"
end

Factory.define :Rick, :class => User do |u|
  u.name                  "Rick"
  u.email                 "rick@gmail.com"
  u.crypted_password      "a7944c46edb15a444ee1facd57fb23cf7d675bf3634e0bd5728d9866bbd8f5154829981e0af0c5b50e2f5534484d8a398363fcd185c3737844e424dd81196907"
end
