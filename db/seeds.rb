3.times do |n|
  table_number = n
  max_size = 5
  Table.create!(table_number: table_number,
     max_size: max_size,
     status: 0)
end

3.times do |n|
  table_number = n + 3
  max_size = 5
  Table.create!(table_number: table_number,
     max_size: max_size,
     status: 1)
end
3.times do |n|
  table_number = n + 6
  max_size = 5
  Table.create!(table_number: table_number,
     max_size: max_size,
     status: 2)
end
