Post.destroy_all
BookTopic.destroy_all
User.destroy_all
Location.destroy_all
Book.destroy_all
Topic.destroy_all
Course.destroy_all

# Creating Users
u1 = User.create(username: "hannah100", password: "hannah", name: "Hannah Jones")

# Creating Books
b1 = Book.create(name: "Psychology for Beginners", author: "Michelle Brown", isbn: "987654321")

# Creating Locations
l1 = Location.create(building: "Powdermaker Hall")
l2 = Location.create(building: "I Building")
l3 = Location.create(building: "Kiely Hall")
l4 = Location.create(building: "Science Building")

# Creating Posts
p1 = Post.create(user_id: u1.id, book_id: b1.id, content: "This book will blow your mind! It is needed for Pysch 101. So contact me if you need it for 10 bucks!", date: "08-30-2019", status: true, location_id: l1.id)

# Creating Topics
t1 = Topic.create(name: "psychology")

# Creating BookTopics
bt1 = BookTopic.create(book_id: b1.id, topic_id: t1.id)

# Creating Courses
c1 = Course.create(name: "Pyschology 101", book_id: b1.id)

puts "It has been seeded."