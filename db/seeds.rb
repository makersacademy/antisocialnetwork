# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Charity.create( name: "The British Red Cross Society",
                registered_number: 220949,
                activities: " The British Red Cross helps people in crisis, whoever and wherever they are.
                              They are part of a global network of volunteers, responding to natural
                              disasters, conflicts and individual emergencies. They enable vulnerable people
                              at home and overseas to prepare for and respond to emergencies in their own communities.",
                image: "charity-logo-spam4-A.jpg",
                url: "http://www.redcross.org.uk/")

Charity.create( name: "Cancer Research UK",
                registered_number: 1089464,
                activities: " Cancer Research aims to save lives by preventing, controlling and curing cancer.
                              They do this through funding world-class research into all aspects of cancer, providing
                              information, and influencing public policy.",
                image: "charity-logo-spam4-B.jpg",
                url: "http://www.cancerresearchuk.org/")

Charity.create( name: "Barnardo's",
                registered_number: 216250,
                activities: " Barnardo's aim to promote the care, safety and upbringing of children and young people by
                              supporting and assisting those in need, their families and their carers; promoting their
                              health, and advancing their education.",
                image: "charity-logo-spam4-C.jpg",
                url: "http://www.barnardos.org.uk/")
d
