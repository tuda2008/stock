# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

AdminUser.create(email: 'admin@breo.cn', password: 'password', password_confirmation: 'password')
User.create(name: '张三', email: 'hehe@breo.cn', mobile: '13800000001', card: '12345678901234567890', cert_id: '211322199104035028', password: 'password', password_confirmation: 'password')
User.create(name: '李四', email: 'haha@breo.cn', mobile: '13800000002', card: '12345678901234567891', cert_id: '511110197106134116', password: 'password', password_confirmation: 'password')
User.create(name: '王五', email: 'test@breo.cn', mobile: '13800000003', card: '12345678901234567892', cert_id: '110221198108215022', password: 'password', password_confirmation: 'password')
StockCompany.create(name: '倍轻松', description: '按摩器材', legal_representative: '张三')