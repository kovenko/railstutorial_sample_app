# Создание проекта #

### Генерация проекта без директории test: ###

    $ rails new railstutorial_sample_app --skip-test-unit

### Для создания тестов добавим гемы: ###

    group :development, :test do
      gem 'rspec-rails', '~> 3.0'
    end
    group :test do
      gem 'capybara'
    end
    $ bundle install
    $ rails generate rspec:install

### Конфигурируем Rails для использования RSpec ###

    $ rails generate rspec:install

В начале файла app/spec/rails_helper.rb вставите строку

    require 'capybara/rspec'

перед строками

    require 'spec_helper'
    require 'rspec/rails'

Перед последней строкой **end** добавьте

      ...
      config.include Capybara::DSL
    end

или придется писать тесты с включением опции **:type => :feature**, как пример

    describe "Тест статических страниц", :type => :feature do
      ...
    end


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

### Тестирование ###

Создадим файл **spec/requests/static_pages_spec.rb** и вставим в него следующий код:

    require 'rails_helper'
    describe "Статическая страница" do
      describe "Home page" do
        it "должна содердать 'Sample App'" do
          visit '/static_pages/home'
          expect(page).to have_content('Sample App')
        end
      end
      describe "Help page" do
        it "должна содержать 'Help'" do
          visit '/static_pages/help'
          expect(page).to have_content('Help')
        end
      end
    end

Запустим тестирование командой

    $ bundle exec rspec spec

Тест начнет проходить после внесения изменений в представления
**app/views/static_pages/home.html.erb**

    <h1>Sample App</h1>
    <p>
      This is the home page for the
      <a href="http://railstutorial.org/">Ruby on Rails Tutorial</a>
      sample application.
    </p>

  и **app/views/static_pages/help.html.erb**

    <h1>Help</h1>
    <p>
      Get help on the Ruby on Rails Tutorial at the
      <a href="http://railstutorial.org/help">Rails Tutorial help page</a>.
      To get help on this sample app, see the
      <a href="http://railstutorial.org/book">Rails Tutorial book</a>.
    </p>

Добавим недостающие страницы

маршрут

    get "static_pages/about"

Задачу в контроллере

    class StaticPagesController < ApplicationController
      ...
      def about
      end
    end

Представление

    <h1>About Us</h1>
    <p>
      The <a href="http://railstutorial.org/">Ruby on Rails Tutorial</a>
      is a project to make a book and screencasts to teach web development
      with <a href="http://rubyonrails.org/">Ruby on Rails</a>. This
      is the sample application for the tutorial.
    </p>

И аналогичный тест

    describe "About page" do
      it "должна содержать 'About Us'" do
        visit '/static_pages/about'
        expect(page).to have_content('About Us')
      end
    end

### Устранение дублирования шаблонами ###

В макете внесем функцию создающую заголовок

    <!DOCTYPE html>
    <html>
    <head>
      <title><%= yield(:title) %></title>
      <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true %>
      <%= javascript_include_tag 'application', 'data-turbolinks-track' => true %>
      <%= csrf_meta_tags %>
    </head>
    <body>
    <%= yield %>
    </body>
    </html>

На страницах представлений инициализируем заголовки

    # app/views/static_pages/home.html.erb
    <% provide(:title, 'Home') %>
    <h1>Sample App</h1>
    <p>
      This is the home page for the
      <a href="http://railstutorial.org/">Ruby on Rails Tutorial</a>
      sample application.
    </p>

### Объединим изменения с мастер-веткой ###

    $ git add .
    $ git commit -m "Finish static pages"
    $ git checkout master
    $ git merge static-pages
    $ git push

