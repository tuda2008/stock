# 内部股权管理系统

bundle install

bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed

bundle exec rails s

open new tab http://127.0.0.1:3000/admin


ruby 2.4.0 && rails 5.2.0