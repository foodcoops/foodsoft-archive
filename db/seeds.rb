# This file contains all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
user_roles = (ENV['ROLES'] || 'admin user VIP').split
user_passwd = ENV['ADMIN_PASSWORD'] || 'changeme'
user_attrs = {
  name: ENV['ADMIN_NAME'] || 'Anton Administrator',
  email: ENV['ADMIN_EMAIL'] || 'admin@example.com',
  password: user_passwd,
  password_confirmation: user_passwd,
}
user = User.create!(user_attrs)
puts "Default user: #{user.name} <#{user.email}>"
user.confirm!
user.add_role :admin

# very basic sample data
Article.create!([
  {supplier_id: 1, name: "Aardbanaan", order_number: "", description: "", manufacturer: "", origin: "", url: "", image: nil, article_category_id: 2, price_id: nil}
])
p = ArticleCategory.create!(name: "Ingredients")
ArticleCategory.create!([
  {name: "Milk", parent: p},
  {name: "Gluten", parent: p},
  {name: "Soy", parent: p}
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
