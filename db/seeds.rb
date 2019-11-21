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

10.times do |n|

  p = Product.create(name: "product_" + n.to_s, category_id: 1, price: 1000 + n, stock: 10 + n)
  p.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "default.png")), filename: "default.png")
  p.save
end

10.times do |n|

  p = Product.create(name: "product_" + (n+10).to_s, category_id: 2, price: 1000 + n, stock: 10 + n)
  p.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "default.png")), filename: "default.png")
  p.save
end

10.times do |n|

  p = Product.create(name: "product_" + (n+20).to_s, category_id: 3, price: 1000 + n, stock: 10 + n)
  p.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "default.png")), filename: "default.png")
  p.save
end

20.times do |n|
  u = User.create!(id: n+3,name: "user"+n.to_s, email: n.to_s + "abc@gmail.com", password: "111111", password_confirmation: "111111", role: 2)
  u.image.attach io: File.open(Rails.root
    .join("app", "assets", "images", "default_user.png")),
    filename: "default_user.png"
  u.save
end

20.times do |n|
  Order.create!(id: n+1, customer_id: rand(3..23),
  staff_id: 2,
  name: "order"+n.to_s,
  person_number: 10,
  status: "paid",
  phone: "11111111",
  address: "tran khat chan",
  total_amount: 10000)
end
