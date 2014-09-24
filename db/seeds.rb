# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) can be set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html
puts 'ROLES'
YAML.load(ENV['ROLES']).each do |role|
  Role.find_or_create_by_name(role)
  puts 'role: ' << role
end
puts 'DEFAULT USERS'
user = User.find_or_create_by_email :name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
puts 'user: ' << user.name
user.confirm!
user.add_role :admin

# very basic sample data
Article.create!([
  {supplier_id: 1, name: "Aardbanaan", order_number: "", description: "", manufacturer: "", origin: "", url: "", image: nil, article_category_id: 2, price_id: nil}
])
ArticleCategory.create!([
  {name: "Ingrediënten", icon: nil, parent_id: nil, lft: 1, rgt: 8, depth: 0},
  {name: "Melk", icon: nil, parent_id: 1, lft: 2, rgt: 3, depth: 1},
  {name: "Gluten", icon: nil, parent_id: 1, lft: 4, rgt: 5, depth: 1},
  {name: "Soja", icon: nil, parent_id: 1, lft: 6, rgt: 7, depth: 1}
])
Supplier.create!([
  {name: "CoolBoer", stype: "farm", email: "cool@boer.test", address: "Damrak, Amsterdam, Nederland", latitude: "52.3752124", longitude: "4.8958764", phone: "1234567890", phone2: "", fax: "", url: "", vat_number: "", chamber_number: "", logo: "farmer.jpeg"},
  {name: "Willem & Drees", stype: "farm", email: "willemdrees@example.com", address: "Graaf van Lynden van Sandenburgweg 6, Cothen", latitude: "52.0006651", longitude: "5.3034849", phone: "0343 767001", phone2: "", fax: "", url: "http://www.willemendrees.nl/", vat_number: "", chamber_number: "", logo: "willem_en_drees.png"},
  {name: "Brouwerij de Prael", stype: "brewery", email: "deprael@example.com", address: "Oudezijds Voorburgwal 30, 1012 GD, Amsterdam", latitude: "52.3752963", longitude: "4.8996704", phone: "020 4084470", phone2: "", fax: "", url: "http://www.deprael.nl/", vat_number: "", chamber_number: "", logo: "de_prael.png"},
  {name: "BioRomeo", stype: "coop", email: "bioromeo@example.com", address: "Zwijnsweg 5, 8307 PP, Ens", latitude: "52.6630527", longitude: "5.838223", phone: "06 27650002", phone2: "", fax: "", url: "http://www.bioromeo.nl/", vat_number: "", chamber_number: "", logo: "BioRomeo.jpg"}
])
ArticlePrice.create!([
  {article_id: 1, unit: "500g", unit_quantity: 1, price: "2.5", deposit: "0.0", tax: "6.0"}
])
