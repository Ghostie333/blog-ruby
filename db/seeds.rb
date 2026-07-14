require "open-uri"

puts "--- Czyszczenie bazy danych... ---"
ActivityLog.destroy_all if defined?(ActivityLog)
Post.destroy_all
Group.destroy_all
User.destroy_all

# Helper do pobierania i przypisywania zdjęć w locie, żeby nie śmiecić w kodzie
def attach_remote_image(record, url, filename, attachment_name = :avatar)
  file = URI.open(url)
  record.send(attachment_name).attach(io: file, filename: filename)
rescue => e
  puts "Nie udało się pobrać zdjęcia dla #{record.class} (#{filename}): #{e.message}"
end

puts "--- Tworzenie użytkowników i admina... ---"
admin = User.create!(
  email: "admin@wp.pl",
  password: "test123",
  password_confirmation: "test123",
  role: "admin"
)
attach_remote_image(admin, "https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80", "admin_avatar.jpg")

user1 = User.create!(
  email: "test1@wp.pl",
  password: "test123",
  password_confirmation: "test123"
)
attach_remote_image(user1, "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80", "user1_avatar.jpg")

user2 = User.create!(
  email: "test2@wp.pl",
  password: "test123",
  password_confirmation: "test123"
)
attach_remote_image(user2, "https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=300&q=80", "user2_avatar.jpg")


puts "--- Tworzenie grup... ---"
group_tech = Group.create!(
  name: "Programowanie i Technologie",
  owner: admin
)
attach_remote_image(group_tech, "https://images.unsplash.com/photo-1517694712202-14dd9538aa97?auto=format&fit=crop&w=500&q=80", "tech_group.jpg")

group_lifestyle = Group.create!(
  name: "Styl życia i Podróże",
  owner: user1
)
attach_remote_image(group_lifestyle, "https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?auto=format&fit=crop&w=500&q=80", "lifestyle_group.jpg")

# Dopisywanie użytkowników do grup
group_tech.users << [ user1, user2 ]
group_lifestyle.users << [ admin, user2 ]


puts "--- Tworzenie postów ze zdjęciami... ---"

post1 = Post.create!(
  title: "Pierwsze kroki w Ruby on Rails",
  content: "<h1>Witaj w świecie Rails!</h1><p>Ruby on Rails to potężny framework. Dzięki ActionText możesz łatwo tworzyć <strong>pogrubiony</strong> lub <em>kursywą</em> pisany tekst bezpośrednio z edytora Trix.</p>",
  user: admin,
  group: group_tech
)
attach_remote_image(post1, "https://images.unsplash.com/photo-1555066931-4365d14bab8c?auto=format&fit=crop&w=800&q=80", "rails_post.jpg", :cover_image)

post2 = Post.create!(
  title: "Dlaczego Docker jest super?",
  content: "<p>Konteneryzacja ułatwia życie programistom. Ten projekt odpala się jedną komendą!</p>",
  user: user1,
  group: group_tech
)
attach_remote_image(post2, "https://images.unsplash.com/photo-1605745341112-85968b19335b?auto=format&fit=crop&w=800&q=80", "docker_post.jpg", :cover_image)

post3 = Post.create!(
  title: "Najpiękniejsze miejsca na weekend w Polsce",
  content: "<p>Oto lista miejsc, które warto odwiedzić w najbliższy weekend...</p>",
  user: user1,
  group: group_lifestyle
)
attach_remote_image(post3, "https://images.unsplash.com/photo-1501555088652-021faa106b9b?auto=format&fit=crop&w=800&q=80", "travel_post.jpg", :cover_image)


puts "--- ZAKOŃCZONO: Baza danych została pomyślnie zasilona! ---"
puts "Konto admina: admin@wp.pl / test123"
