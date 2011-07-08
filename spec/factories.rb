# By using the symbol ':user', we get Factory Girl to simulate the User model.

Factory.define :user do |user|
  user.name                  "Michael Hartl"
  user.email                 "mhartl@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.define :Admin, :class => User do |u|
  u.name                  "Adam"
  u.email                 "adam@gmail.com"
  u.password              "password"
  u.password_confirmation "password"
end
  
Factory.define :Figo, :class => User do |u|
  u.name                  "Figo"
  u.email                 "figo@gmail.com"
  u.password              "password"
  u.password_confirmation "password"
end

arden = Factory.define :Arden, :class => User do |u|
  u.name                  "Arden"
  u.email                 "arden@gmail.com"
  u.password              "password"
  u.password_confirmation "password"
end

Factory.define :Unice, :class => User do |u|
  u.name                  "Unice"
  u.email                 "unice@gmail.com"
  u.password              "password"
  u.password_confirmation "password"
  
end

Factory.define :Rick, :class => User do |u|
  u.name                  "Rick"
  u.email                 "rick@gmail.com"
  u.password              "password"
  u.password_confirmation "password"
end