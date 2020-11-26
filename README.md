# bookmark-challenge

## First steps

1. Set up environment with Gemfile
2. Set up config.re
3. Set up spec_helper file
4. Initialise rspec
5. Set up app.rb requiring sinatra
6. Set up lib, spec and views folders


## User story 1

```
As a user
So I can access websites quickly
I want to see a complete list of my bookmarks
```

1. Start with testing features for the simplest thing possible
  - think: what do I expect to be shown in what route?
  - create the simplest feature test to show 'hello world in the main route '/'
  - create index.erb file with 'hello world' to be shown
  - append this route to app.rb, so the server can show
  - run the server 
  - run rspec

  Diagram: 

2. Then start testing how to show all bookmarks
  - create /bookmarks route
  - append the route to app.rb
  - create a view file to be shown in the route /bookmarks
  - create feature test this route
  - create unit test for this route for #all method
  - implement the code according to rspec results
    - think: the #all method can be solely a class method, calling self.all in the model
    - to show the list of bookmarks, instead of hardcoding 'list of bookmarks', create a @bookmarks = Bookmark.all in app.rb and in the bookmarks.erb, call <%= @bookmarks %>
    - then refactor the what needs to be refactored

### More

  - the list of bookmarks is hardcoded at the moment
  - it is time to progress to a database

1. Create database in PostgreSQL using CREATE DATABASE and CREATE TABLE commands and create db/migrations files
2. CREATE DATABASE bookmarks; then acces this database with \c
3. CREATE TABLE bookmark_manager (id SERIAL PRIMARY KEY, url VARCHAR(60));
4. Use CRUD (create, read, update and delete) for SQL
5. Insert data into database using:
  - INSERT INTO bookmark_manager (url) VALUES ('http://www.makersacademy.com');
  - play with SELECT and UPDATE commands to get used to SQL language
6. Install gem 'pg' and run bundle install
7. Integrate PostgreSQL with Ruby through pg
  - Check on irb how PG connects ruby to database using:
    ```
    require 'pg'
    connection = PG.connect(dbname: 'bookmarks')
    result = connection.exec('SELECT * FROM bookmark_manager')
    result.each { |bookmark| p bookmark }
    ```
    - this should show the entries in the database
8. Require pg in the bookmark.rb
9. Refactor the .all method to connect to the database through pg, mapping the result
10. All tests should pass
11. Connect TablePlus to your database if you want

--> for the testing enviroment, create a database and table with the same columns

--> refactor .all method to accept the test database environment as well as add requirements in spec_helper (ENV['RACK_ENV'] = 'test')

--> refactor unit test to accept a test database connection

--> setup database to clear test database at each call (spec/setup_test_database.rb)

--> populate spec and feature tests with the connection to the test database

--> change requirements in spec_helper to access the setup_test_database file each time before the tests run

--> be aware that your setup_test_database file has a method with the same name to be able to run


## User story 2
```
As a user
So that I can save a website
I would like to add a bookmark to the bookmark manager
```
### feature test
1. To implement, start with feature test ( to see the route and what needs to be done, just add the route you want to the url and read Sinatra's message)


