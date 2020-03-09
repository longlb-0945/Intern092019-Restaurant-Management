Table.delete_all
User.delete_all
Order.delete_all
OrderTable.delete_all


3.times do |n|
  table_number = n +1
  max_size = 5
  Table.create!(
  id: n+1,
  table_number: table_number,
     max_size: max_size,
     status: 0)
end

3.times do |n|
  table_number = n + 4
  max_size = 5
  Table.create!(
    id: n+4,
  table_number: table_number,
     max_size: max_size,
     status: 1)
end

3.times do |n|
  table_number = n + 7
  max_size = 5
  Table.create!(
    id: n+7,
  table_number: table_number,
     max_size: max_size,
     status: 2)
end

u = User.create!(id: 1, name: "admin", email: "abc@gmail.com", password: "111111", password_confirmation: "111111", role: 0)
u.image.attach io: File.open(Rails.root
  .join("app", "assets", "images", "default_user.png")),
  filename: "default_user.png"
u.save

u = User.create!(id: 2, name: "staff", email: "abc2@gmail.com", password: "111111", password_confirmation: "111111", role: 1)
u.image.attach io: File.open(Rails.root
  .join("app", "assets", "images", "default_user.png")),
  filename: "default_user.png"
u.save

c = Category.create(id: 1, name: "food")
c.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "category.png")), filename: "default.png")
c.save

c = Category.create(id: 2, name: "drink")
c.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "category.png")), filename: "default.png")
c.save

c = Category.create(id: 3, name: "fast food")
c.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "category.png")), filename: "default.png")
c.save

c = Category.create(id: 4, name: "breakfast")
c.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "breakfast-6.jpg")), filename: "breakfast-6.jpg")
c.save

c = Category.create(id: 5, name: "lunch")
c.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "lunch-1.jpg")), filename: "lunch-1.jpg")
c.save

c = Category.create(id: 6, name: "dinner")
c.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "dinner-1.jpg")), filename: "dinner-1.jpg")
c.save

10.times do |n|

  p = Product.create(name: "product_" + n.to_s, category_id: 1, price: 1000 + n, stock: 10 + n, short_description: "dn't call delicious that what is tasteless or unpleasant")
  p.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "lunch-3.jpg")), filename: "lunch-3.jpg")
  p.save
end

5.times do |n|

  p = Product.create(name: "bread " + n.to_s, category_id: 5, price: 1000 + n, stock: 10 + n, short_description: "enjoyable, appealing, enchanting, charm tasteless or unpleasant")
  p.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "lunch-2.jpg")), filename: "lunch-2.jpg")
  p.save
end

5.times do |n|

  p = Product.create(name: "lunch " + n.to_s, category_id: 4, price: 1000 + n, stock: 10 + n, short_description: " charming. You wouldn't call delicious that what is tasteless or unpleasant")
  p.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "breakfast-8.jpg")), filename: "breakfast-8.jpg")
  p.save
end

5.times do |n|

  p = Product.create(name: "dinner " + n.to_s, category_id: 6, price: 1000 + n, stock: 10 + n, short_description: "u wouldn't call delicious that what is tasteless or unpleasant")
  p.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "dinner-2.jpg")), filename: "dinner-2.jpg")
  p.save
end

10.times do |n|

  p = Product.create(name: "product_" + (n+10).to_s, category_id: 2, price: 1000 + n, stock: 10 + n, short_description: " wouldn't call delicious that what is tasteless or unpleasant")
  p.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "lunch-4.jpg")), filename: "lunch-4.jpg")
  p.save
end

10.times do |n|

  p = Product.create(name: "product_" + (n+20).to_s, category_id: 3, price: 1000 + n, stock: 10 + n, short_description: "ldn't call delicious that what is tasteless or unpleasant")
  p.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "dinner-3.jpg")), filename: "dinner-3.jpg")
  p.save
end

20.times do |n|
  u = User.create!(id: n+3,name: "user"+n.to_s, email: n.to_s + "abc@gmail.com", password: "111111", password_confirmation: "111111", role: 2)
  u.image.attach io: File.open(Rails.root
    .join("app", "assets", "images", "default_user.png")),
    filename: "default_user.png"
  u.save
end

5.times do |n|
  Order.create!(id: n+1, customer_id: rand(3..23),
  staff_id: 2,
  name: "order"+n.to_s,
  person_number: 10,
  status: "paid",
  phone: "11111111",
  address: "tran khat chan",
  start_time: "2019-12-25 " + "13:" + (n+1).to_s + ":00",
  total_amount: rand(30000..1000000))
end

5.times do |n|
  Order.create!(id: n+6, customer_id: rand(3..23),
  staff_id: 2,
  name: "order"+n.to_s,
  person_number: 10,
  status: "paid",
  phone: "11111111",
  address: "tran khat chan",
  start_time: "2019-12-26 " + "13:" + (n+6).to_s + ":00",
  total_amount: rand(30000..1000000))
end

5.times do |n|
  Order.create!(id: n+11, customer_id: rand(3..23),
  staff_id: 2,
  name: "order"+n.to_s,
  person_number: 10,
  status: "paid",
  phone: "11111111",
  address: "tran khat chan",
  start_time: "2019-12-24 " + "13:" + (n+11).to_s + ":00",
  total_amount: rand(30000..1000000))
end
