Table.delete_all
User.delete_all
Order.delete_all
OrderTable.delete_all


3.times do |n|
  table_number = n
  max_size = 5
  Table.create!(
  id: n+1,
  table_number: table_number,
     max_size: max_size,
     status: 0)
end

3.times do |n|
  table_number = n + 3
  max_size = 5
  Table.create!(
    id: n+4,
  table_number: table_number,
     max_size: max_size,
     status: 1)
end

3.times do |n|
  table_number = n + 6
  max_size = 5
  Table.create!(
    id: n+7,
  table_number: table_number,
     max_size: max_size,
     status: 2)
end

User.create!(id: 1, name: "CUSTOMER")
User.create!(id: 2, name: "STAFF", role: 1)

Order.create!(id: 1, customer_id: 1,
  staff_id: 2,
  name: "aaaa",
  person_number: 10,
  total_amount: 10000)

OrderTable.create!(order_id: 1,
  table_id: 1)
OrderTable.create!(order_id: 1,
  table_id: 2)
OrderTable.create!(order_id: 1,
  table_id: 3)
