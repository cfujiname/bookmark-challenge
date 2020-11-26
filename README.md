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
[![bookmark-manager.png](https://i.postimg.cc/FRsCrVJT/bookmark-manager.png)]

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

1. To implement, start with feature test (to see the route and what needs to be done, just add the route you want to the url and read Sinatra's message)
2. Implement the route in app.rb to see what the route shows
3. Refactor the test to be able to fill in a form and click on a button to submit the request
4. Rspec will fail (Unable to find field "url" that is not disabled): we don't have a form or field yet in our page
5. In app.rb, add the erb 'file' that will be used to call this feature
6. Tests will still fail as there is no view file to be called (No such file or directory @ rb_sysopen - /Users/cristinafujiname/Consolidation/bookmark-challenge/views/bookmarks/new.erb)
7. Tests will still fail as (Unable to find button "Submit" that is not disabled): there is no button in the form I have just created
8. Implement a button 'submit' in the form
9. Test fails (expected to find text "http://www.hello.com" in ""): the method at the moment in the form is GET (by default), so we need to change it to POST as it is a POST request
10. Test still fails (expected to find text "http://www.hello.com" in "POST /bookmarks"): Sinatra has no POST in app.rb, so we need to create a POST request
11. In app.rb, print params and some stringified message and run rspec: 
```
{"url"=>"http://www.hello.com", "Submit"=>""}
"stringified message"
```
  - this is printed in the terminal
  - and there is still an error (expected to find text "http://www.hello.com" in "stringified message")
  - to solve this, we need to get the 'url' from the form that was submitted (params)
  - there needs to be database connection to be able to pass this url to the table
  - execute the connection to insert the url to the table
  - redirect, after clicking submit, to the /bookmarks route which shows all the added bookmarks

12. Refactor time: extract the database connection from app.rb and implement the create method in the model, refactor also the feature tests to accept the method .create

## Adding 'title' to the database

1. For organisation purposes, we will add title to each URL, so it looks nicer
2. Alter the tables in the database to accept title with the URLs (for test and normal)
3. The user needs to be able to add the title of the bookmarks as well using a form, so update the feature test .create to accept title as well as the url, linking the url to the title with href - for this, create a new feature test file create_bookmark_spec and extract from controller_spec what is related to create
4. Tests fail as we don't have a field 'title' in our view: pass the title field to new.erb
5. The field title needs to be passed to the controller as it needs now 2 parameters
6. Unit tests will fail as our method .create still only accepts the url parameter. Add title parameter to test and now, because we have a list of bookmarks, we need to call method .first to fetch the correct one
7. To pass the tests, we need to adjust our method in the model to accept the title and insert the field into the database connection as well - and asking the database to return id, url and title
8. Feature tests still fail as we need to pass the title there as well: view_bookmark_spec is a new file and the test is extracted from controller, adjusted with the title parameter and the page expects to have a link eith title and href
9. Unit test for .all needs to be refactored as well to accept an instance of the class and then expectations will be related to the length of the array and using id, url and title, as well as the first positions of the array
10. The test above will ask you to basically to update the .all method in the model to accept a new instance of Bookmark with all three parameters included, fetching those infos from the database
11. After that, we will need to initalize id, title and url in the class for these parameters to be passed correctly
12. In .create, we need to refactor it so it creates a new object of Bookmark and checks the values of it instead of relying on the result of calling .all
13. Here, create an instance that uses the method .create to include url and title to the database
14. Create also a persisted_data variable that connects to the database and queries from there according to id.
15. Now in the model, it is necessary to pass to the new Bookmark object, the parameters id, url and title according to their position in the array
16. Refactor the persisted_data into a method in a file called database_helpers.rb, which takes id as a parameter and the connection queries according to id
17. In the unit test, pass the persisted_data with the id parameter and expect the id to eq the persisted data passed with id parameter

