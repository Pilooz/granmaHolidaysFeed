# encoding: utf-8
source 'https://rubygems.org'

# Ramaze
gem 'ramaze'

# Rake
gem 'rake'

# Database
#gem 'sequel'

# Web server
gem 'thin'

# Metriques
gem 'fnordmetric'
# Suivant la version en cours du gem :
# gem 'fnordmetric', :git => 'https://github.com/hewo/fnordmetric.git', :branch => 'master'
#gem 'ramaze-fnordmetric-helper'

# Redis
gem 'redis'

# Hashage
# Chiffrement mots de passe et génération de UUIDs secure (SecureRandom)
#gem 'bcrypt-ruby'

# Email
#gem 'pony'

# JSON
# TODO: choisir le bon gem, y'en plein
gem 'json'     

# Background tasks
#gem 'sidekick' 
# ou gem 'resque' ou ...

# Requètes HTTP
# soit la stdlib, soit autre chose, par exemple :
#gem 'typhoeus'

# Twitter
#gem 'tweetstream'

# Mail
gem 'mail' 

# Exif lib
gem 'exifr'

 
# Gems pour le dev
group :development do
  # Base pour le dev
  # NOTE: Pas très recommandé de développer sur un backend différent de la
  # prod...
  # gem 'sqlite3'
  # L'indispensable lolcommits
  # Faire suivre de lolcommits --enable (attention, s'il y a déjà un post
  # commit hook activé, il faut l'ajouter à la main)
  gem 'lolcommits'
  # Testing methods for Rack
  gem 'rack-test'
  # Tests
  gem 'bacon'
  # Pour la parsing de résponses de test
  gem 'nokogiri'
  # Couverture de tests
  gem 'simplecov'
  # Doc
  gem 'yard'
  # Pour avoir la doc en ligne de commande
  # Faire suivre avec rdoc-data --install
  # THINK: Peut etre une tache rake dans un namespace dev: ?
  gem 'rdoc'
  gem 'rdoc-data'
end

# Gems de déploiement
group :deploy do
  # Deploiement
  gem 'mina'
end

