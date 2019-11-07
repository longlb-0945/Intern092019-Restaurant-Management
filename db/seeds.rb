Table.delete_all
User.delete_all
Order.delete_all
OrderTable.delete_all


3.times do |n|
  table_number = n + 1
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

u = User.create!(id: 1, name: "admin", email: "abc@gmail.com", role: 0, password: "111111", password_confirmation: "111111")
u.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "default_user.png")), filename: "category.png")
u.save

c = Category.create(id: 1, name: "food")
c.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "category.png")), filename: "default.png")
c.save

20.times do |n|

  p = Product.create(name: "product_" + n.to_s, category_id: 1, price: 1000 + n, stock: 10 + n)
  p.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "default.png")), filename: "default.png")
  p.save
end
