#!/bin/bash

set -e  # Exit on any error

# Variables
APP_NAME="dv4"
LEGACY_APP="dv"
DB_NAME="dv4_development"
DB_USER="postgres"
DB_PASS="password"
RUBY_VERSION="3.2.2"
NODE_VERSION="18"
YARN_VERSION="latest"

# # Step 1: Install dependencies (if needed)
# echo "Installing required dependencies..."

# if [[ "$OSTYPE" == "darwin"* ]]; then
#   # macOS specific installation
#   brew update
#   brew install curl git node@$NODE_VERSION yarn postgresql@16 rbenv ruby-build
#   brew services start postgresql@16

#   # Setup rbenv and install Ruby
#   eval "$(rbenv init -)"
#   rbenv install -s $RUBY_VERSION
#   rbenv global $RUBY_VERSION
#   gem install bundler
# else
#   # Linux installation
#   sudo apt update
#   sudo apt install -y curl git nodejs yarn postgresql postgresql-contrib libpq-dev build-essential libssl-dev zlib1g-dev \
#     libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common \
#     libffi-dev ruby-dev rbenv ruby-build

#   # Setup rbenv and install Ruby
#   eval "$(rbenv init -)"
#   rbenv install -s $RUBY_VERSION
#   rbenv global $RUBY_VERSION
#   gem install bundler
# fi

# # Step 2: Setup PostgreSQL
# echo "Setting up PostgreSQL..."
# if [[ "$OSTYPE" == "darwin"* ]]; then
#   createuser -s $DB_USER || true
#   createdb $DB_NAME -O $DB_USER
# else
#   sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASS';"
#   sudo -u postgres psql -c "CREATE DATABASE $DB_NAME OWNER $DB_USER;"
#   sudo -u postgres psql -c "ALTER USER $DB_USER CREATEDB;"
# fi

# # Step 3: Create a new Rails 7 application
# echo "Creating new Rails 7 application: $APP_NAME..."
# gem install rails -v 7.0.4
# rails new $APP_NAME -d postgresql --skip-javascript --skip-turbolinks
# cd $APP_NAME

# # Step 4: Configure database connection
# cat <<EOL > config/database.yml
# default: &default
#   adapter: postgresql
#   encoding: unicode
#   pool: 5
#   username: $DB_USER
#   password: $DB_PASS
#   host: localhost

# development:
#   <<: *default
#   database: $DB_NAME

# test:
#   <<: *default
#   database: ${DB_NAME}_test

# production:
#   <<: *default
#   database: ${DB_NAME}_production
# EOL

# # Step 5: Install gems (Replace Gemfile with necessary gems)
# echo "Updating Gemfile..."
# cat <<EOL > Gemfile
# source "https://rubygems.org"

# gem "rails", "7.0.4"
# gem "pg"
# gem "sassc-rails"
# gem "jquery-rails"
# gem "devise"
# gem "ckeditor"
# gem "font-awesome-rails"
# gem "jquery-ui-rails"
# gem "thinking-sphinx"
# gem "bootstrap"
# gem "tabler-rubygem"
# gem "diffy"
# gem "will_paginate"
# gem "rails-html-sanitizer"
# gem "jwt"
# gem "rack-cors"
# gem "docx_replace"
# gem "roo"
# gem "rqrcode"
# gem "x-editable-rails"
# gem "sidekiq"
# gem "redis"
# gem "hiredis"
# gem "httparty"
# gem "savon"
# group :development, :test do
#   gem "byebug"
# end
# group :development do
#   gem "web-console"
#   gem "spring"
# end
# EOL

# bundle install

# # Step 6: Run migrations
# echo "Running database migrations..."
# cp /mnt/data/20250125200134_create_all_tables.rb db/migrate/
# cp /mnt/data/20250125200134_add_indexes_to_tables.rb db/migrate/
rails db:migrate

# Step 7: Copy files from legacy Rails app
echo "Copying necessary files from legacy app ($LEGACY_APP) to new app ($APP_NAME)..."
rsync -av --progress ../$LEGACY_APP/app/models/ app/models/
rsync -av --progress ../$LEGACY_APP/app/controllers/ app/controllers/
rsync -av --progress ../$LEGACY_APP/app/views/ app/views/
rsync -av --progress ../$LEGACY_APP/app/services/ app/services/
rsync -av --progress ../$LEGACY_APP/app/jobs/ app/jobs/
rsync -av --progress ../$LEGACY_APP/app/helpers/ app/helpers/
rsync -av --progress ../$LEGACY_APP/app/assets/ app/assets/
rsync -av --progress ../$LEGACY_APP/lib/ lib/
rsync -av --progress ../$LEGACY_APP/config/locales/ config/locales/

# Step 8: Cleanup and Final Steps
echo "Setup complete! Start the server with:"
echo "cd $APP_NAME && rails server"
