# bookmark-challenge

## First steps

1. Set up environment with Gemfile
2. Set up config.re
3. Set up spec_helper file
4. Initialise rspec
5. Set up app.rb requiring sinatra
6. Set up lib, spec and views folders

(feature, view, controller, unit, model, refactor controller  )

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
![bookmark-manager.png](https://i.postimg.cc/FRsCrVJT/bookmark-manager.png)

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

## User story 3

```
As a user
So I can remove my bookmark from Bookmark Manager
I want to delete a bookmark
```

1. Start with the feature test: the user could be able to delete a bookmark when he visists the '/bookmarks' page and clicks on a delete button beside the chosen url, then he sees the page without the url he just deleted
2. Create a new features file delete_bookmark_spec.rb
3. For the test, we need to create the context: create a bookmark, visit the route '/bookmarks', expect the page to have the link, then click on delete that is related to that specific bookmark, then expect the page to be in the current path '/bookmarks' an dnot to have the link and title of the url he just deleted
  - Capybara method 'first' is looking into the first element in the class bookmark
4. Test fails (expected to find css ".bookmark" at least 1 time but there were no matches): the class bookmark is not yet in the html list and delete button is as well inexistent
5. Go to index.erb to fix it, add the 'delete' button, which will be a form with method post
6. In the controller, create a delete function and print the params in the terminal when running the tests, to see which params are used with the method 'delete'
7. Refactor the method to make a connection to the test database, asking it to delete from the test database where the id is the params id, redirecting to '/bookmarks' afterwards
8. Create the unit test for the .delete by creating a bookmark and then deleting it with id as a parameter, then expecting the length of Bookmark.all to eq 0
9. In the model, create the .delete method with the PG connection similar to the one in the controller, as we are now extracting this connection to the model instead of leaving it in the controller
10. Tests should pass now, then refactor the controller for, instead of having the connection, to just delete a bookmark through its id and redirect to '/bookmarks'

## User story 4

```
As a user
So I can change a bookmark in Bookmark Manager
I want to update a bookmark
```
1. Start as usual with feature test, creating a new update_bookmark_spec.rb file
2. First part of the test is to create a bookmark for the context, then visit the the path '/bookmarks' and expect the page to have the link
3. Second part is to catch the first bookmark of the array and click 'edit' by it, expecting the current path to be '/bookmarks/id/edit'
4. Fill in the form with url and title fields, click submit
5. Expect the current path to be '/bookmarks/ as we want to redirect always to this path
6. Expect the page to not have the previous link and have the new link
7. Tests will fail as we need to change out view to accept this edit form and button with a get method
8. Now, we need to implement in the model the get path with the edit route
9. Then create another view for edit edit.erb and create the view with PATCH value and POST method
10. In the controller, add the patch method with a connection to the database with the UPDATE command, taking url and title where there is a specific id
11. Create the unit test for the method .update by creating the context of a new variable that equals to creating a new bookmark, then another updated_bookmark variable with id, updated url and title
12. Expectations must be_a Bookmark, id equals id and title and url equals the new data passed into updated_bookmark
13. Rspec still fails as it does not recognize the method .update, so it needs to be implemented in the model
14. Implement the method by extracting the connection from the controller to the model with respective syntax
15. Refactor the model to fetch the params from the database, keep the redirection
16. For organisational purposes and better user experience, it would be better if the user could see which url and title he wants to update in the edit form
17. For that, we need to pass a Bookmark object that wraps the data for that specific bookmark - when we call .all, all the bookmarks are passed, so to pull only one bookmark out we could implement a method .find
18. In the controller, change the edit path to accept Bookmark.find with id params
19. In the unit test, implememnt a test for .find method
20. Implement the .find method in the model with the connection to database and the result connecting to database, selectring from table where id is the selected id, creating a new bookmark object with the parameters
21. Refactor the edit.erb to look for the @bookmark.id

## Extracting database setup object

1. This is kind of a refactor: you can see in the model that we are repeating the connection each time we create a new method. We shall extract this connection and assign it to an object that will handle the connection
2. In the model, define the variable 'result' to use the object DatabaseConnection with the .query method, taking the sql command as an argument
3. Extract the database connection logic to the object - start by writing a test in a new spec file database_connection_spec.rb - the test should check the .setup method at first and, setting up a connection through PG, expecting PG to receive :connect with the database name
4. The object should then .setup('database_test')
5. Now we need to implement the .setup method in the model, creating a new file and class
6. Write the .setup method, having the database name as a paramenter - this method should create a PG.connect
7. Write another test to check if the connection is persistent, expecting the object.connection to eq the connection
8. Create a database_connection.rb file and implement the methods .setup with the database as a parameter and .connection
9. Now we need to use the object to setup the connection de facto: create a database_connection_setup.rb file and write the conditional statement that will connect the database to the correct one, either test or normal - and don't forget to require the file in app.rb 
10. Now in the model, we can use the object and a .query method to be able to query the info from the database in the all its methods, requiring database_connection and unrequiring pg in the file, removing the PG connection from the methods
11. Implement a test for .query, setting up a connetion variable that sets up the database and expecting the connection to receive :exec with the desired query, and the object.query must retrieve the query
12. To pass the test, we need to create a .query method in the database_connection class, which takes sql as a parameter

## Validations

1. Start by adding a feature test (another scenario) for invalid url - visit bookmarks, fill in url with not an url, click submit and expect not to have the wrong url and to have 'You must submit a valid url





