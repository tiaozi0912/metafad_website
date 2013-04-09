# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                   "Yujun Wu"
  user.email                  "wyj0912@gmail.com"
  user.password               "foobar"
  user.password_confirmation  "foobar"
end