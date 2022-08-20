require 'csv'

dog_csv = File.read(Rails.root.join('db','csv_seeds', 'dog.csv'))
park_csv = File.read(Rails.root.join('db','csv_seeds', 'park.csv'))

# USERS
p "creating users"
counter = 0
u = User.create!(
  first_name: "Bob",
  last_name: "Ross",
  biography: "I used to be a painter but now I walk dogs for a living.",
  email: "bob@ross.com",
  password: "123456"
)
counter += 1 if u.persisted?
p ""
p ">>> #{counter} #{'user'.pluralize(counter)} generated"

# DOGS
p "creating dogs"
dog_csv_data = CSV.parse(dog_csv, headers: true, encoding: 'ISO-8859-1')
counter = 0
dog_csv_data.each do |row|
  d = Dog.create!(
    name: row['name'],
    breed: row['breed'],
    colour: row['colour'],
    age: row['age'],
    biography: row['biography'],
    user_id: 1
  )
  counter += 1 if d.persisted?
  print "."
end
p ""
p ">>> #{counter} #{'dog'.pluralize(counter)} generated"

# ACTIVITIES
p ""
p "creating activities - parks"
counter = 0
park_csv_data = CSV.parse(park_csv, headers: true, encoding: 'ISO-8859-1')
park_csv_data.each do |row|
  a = Activity.create!(
    name: row["name"],
    description: row["description"],
    category: row["category"],
    park_feature: row["park_feature"],
    user_id: 1
  )
  a.location = Location.create(
    street: row["street"],
    city: row["city"],
    postcode: row["postcode"]
  )
  counter += 1 if a.persisted?
  print "."
end

p ""
p "creating activities - restaurants"
a = Activity.create!(
  name: "Starbucks",
  description: "Chain coffee shop near Hyde Park",
  category: "restaurant",
  restaurant_type: "cafe",
  user_id: 1
)
print "."
counter += 1 if a.persisted?

p ""
p "creating activities - dog bins"
a = Activity.create!(
  name: "Dog Bin, Hyde Park",
  description: "A dog bin park in Hyde Park",
  category: "dog bin",
  user_id: 1
)
print "."
p ""
counter += 1 if a.persisted?
p ">>> #{counter} #{'activity'.pluralize(counter)} generated"

# REVIEWS
p "creating reviews"
counter = 0
r = Review.create!(
  content: "Amazing park! Very dog friendly!",
  rating: 9,
  user_id: 1,
  activity_id: 1
)
counter += 1 if r.persisted?
r = Review.create!(
  content: "Average coffee but allows dogs",
  rating: 5,
  user_id: 1,
  activity_id: 2
)
counter += 1 if r.persisted?
r = Review.create!(
  content: "Convenient dog bin, but often litter is everywhere",
  rating: 5,
  user_id: 1,
  activity_id: 3
)
counter += 1 if r.persisted?
p ">>> #{counter} #{'activity'.pluralize(counter)} generated"

# Locations - Polymorphic seeding
# > Create new Location instance first
# > Then attach to locatable (either User or Activity), like so:
#     User.first.location = Location.create(
#       street: "test",
#       city: "test",
#       postcode: "test"
#     )
p "creating locations"
counter = 0
User.all.each do |user|
  l = Location.create(
    street: "#{user.id} Test Street",
    city: "London",
    postcode: "E#{user.id} 1AA"
  )
  user.location = l
  counter += 1 if l.persisted? & user.persisted?
end
p ">>> #{counter} #{'location'.pluralize(counter)} generated"
