# Создание проекта #

### Генерация проекта без директории test: ###

    $ rails new railstutorial_sample_app --skip-test-unit

### Для создания тестов добавим гемы: ###

    group :development, :test do
      gem 'rspec-rails', '2.13.1'
    end
    group :test do
      gem 'capybara', '2.1.0'
    end
    bundle install

### Конфигурируем Rails для использования RSpec ###

    $ rails generate rspec:install


### Динамическая генерация секретного токена ###

Добавим файл config/initializers/secret_token.rb

    require 'securerandom'

    def secure_token
      token_file = Rails.root.join('.secret')
      if File.exist?(token_file)
        # Use the existing token.
        File.read(token_file).chomp
      else
        # Generate a new token and store it in token_file.
        token = SecureRandom.hex(64)
        File.write(token_file, token)
        token
      end
    end

    SampleApp::Application.config.secret_key_base = secure_token

### Инициализация Git репозитория: ###

    $ git init
    $ git add .
    $ git commit -m "Initial commit"
    $ git remote add origin https://github.com/<username>/railstutorial_sample_app.git
    $ git push -u origin master

# Статические страницы #

### Генерация контроллера StaticPages ###
    $ rails generate controller StaticPages home help --no-test-framework

Будет сгенерирован контроллер, представления и добавлены маршруты.

Если вдруг допущена ошибка, можно сделать **откат генерации**

    $ rails destroy controller StaticPages home help --no-test-framework

Если требуется **откатить миграцию**

    $ rake db:rollback

**Опкатить миграции до нужной версии**, как пример к началу

    $ rake db:migrate VERSION=0

Генерация создаст два маршрута

    get "static_pages/home"
    get "static_pages/help"

Запустим сервер и посмотрим страницу

    $ rails s
    http://localhost:3000/static_pages/home

Если увидете **ошибку ExecJS**, добавьте гем

    gem 'coffee-script-source', '1.8.0'
    $ bundle update
    $ bundle install



