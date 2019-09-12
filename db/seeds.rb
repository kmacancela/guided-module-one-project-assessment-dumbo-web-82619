Post.destroy_all
BookTopic.destroy_all
User.destroy_all
Location.destroy_all
Book.destroy_all
Topic.destroy_all
Course.destroy_all

# Creating Users
u1 = User.create(username: "hannah100", password: "hannah", name: "Hannah Jones")
u2 = User.create(username: "kim100", password: "kim", name: "Kim Leslie")
u3 = User.create(username: "john100", password: "john", name: "John Smith")

# Creating Books
b1 = Book.create(title: "Psychology for Beginners", author: "Michelle Brown", isbn: "987654321")
b2 = Book.create(title: "Animal Farm", author: "George Orwell", isbn: "9273393873")
b3 = Book.create(title: "Astrology for Beginners", author: "Jessie James", isbn: "82929383999")

# Creating Locations
l1 = Location.create(building: "Powdermaker Hall")
l2 = Location.create(building: "I Building")
l3 = Location.create(building: "Kiely Hall")
l4 = Location.create(building: "Science Building")

# Creating Posts
p1 = Post.create(user_id: u1.id, book_id: b1.id, content: "This book will blow your mind! It is needed for Pysch 101. So contact me if you need it for 10 bucks!", date: "2019-08-30", status: true, location_id: l1.id)
p2 = Post.create(user_id: u1.id, book_id: b1.id, content: "Buy this book from me! I will give you the best price for shizzle.", date: "2019-09-01", status: true, location_id: l3.id)
p3 = Post.create(user_id: u2.id, book_id: b1.id, content: "Contact me if you want it I guess. I can give it away for free if you really need it...", date: "2019-09-05", status: true, location_id: l2.id)
p4 = Post.create(user_id: u3.id, book_id: b3.id, content: "I learned so much about myself from this book omg! Haters gonna hate. Get this book from me for 5 dollars. Only this week yo", date: "2019-08-22", status: true, location_id: l4.id)
p5 = Post.create(user_id: u2.id, book_id: b2.id, content: "This book is needed for personal growth and stuff. I'm super serious. You'll love it. Call me for the price.", date: "2019-09-10", status: true, location_id: l3.id)

# Creating Topics
t1 = Topic.create(name: "psychology")

# Creating BookTopics
bt1 = BookTopic.create(book_id: b1.id, topic_id: t1.id)

# Creating Courses
c1 = Course.create(name: "Pyschology 101", book_id: b1.id)

puts "It has been seeded."