# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

AdminUser.create(email: 'admin@breo.cn', password: 'password', password_confirmation: 'password')
User.create(name: '张三', email: 'hehe@breo.cn', mobile: '13800000001', bank_name: 'sz', card: '12345678901234567890', cert_id: '211322199104035028', cert_address: 'sz')
StockCompany.create(name: '深圳市倍轻松科技股份有限公司', description: '按摩器材')
StockCompany.create(name: '深圳市鼎元宏投资有限公司', description: '按摩器材')
StockCompany.create(name: '深圳市倍润投资有限公司', description: '按摩器材')