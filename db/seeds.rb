# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Language.create(abbreviation: 'en', name: 'English')
Language.create(abbreviation: 'fr', name: 'French')
Language.create(abbreviation: 'es', name: 'Spanish')
Language.create(abbreviation: 'ko', name: 'Korean')
Language.create(abbreviation: 'de', name: 'German')
Language.create(abbreviation: 'ru', name: 'Russian')
Language.create(abbreviation: 'pt', name: 'Portuguese')
Language.create(abbreviation: 'th', name: 'Thai')
Language.create(abbreviation: 'zh', name: 'Chinese')
Language.create(abbreviation: 'tr', name: 'Turkish')
Language.create(abbreviation: 'ja', name: 'Japanese')
Language.create(abbreviation: 'pl', name: 'Polish')

Game.create(name: "none", category: "none", twitch_game_id: "0")
