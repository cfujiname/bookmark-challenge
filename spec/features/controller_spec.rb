feature 'Page shows Hello World' do
  scenario 'shows Hello World' do
    visit('/')
    expect(page).to have_content 'Hello World'
  end
end

feature 'Page shows all bookmarks' do
  scenario 'show list of bookmarks' do
    visit('/bookmarks')
    expect(page).to have_content ('http://www.google.com')
  end
end

feature 'Viewing bookmarks' do
  scenario 'User can see list of bookmarks' do
    connection = PG.connect(dbname: 'bookmarks_test')
    connection.exec("INSERT INTO bookmark_manager_test (url) VALUES ('http://www.makersacademy.com');")
    connection.exec("INSERT INTO bookmark_manager_test (url) VALUES ('http://www.destroyallsoftware.com');")
    connection.exec("INSERT INTO bookmark_manager_test (url) VALUES ('http://www.google.com');")
    visit('/bookmarks')
    expect(page).to have_content('http://www.makersacademy.com')
    expect(page).to have_content('http://www.google.com')
    expect(page).to have_content('http://www.destroyallsoftware.com')
  end
end

feature 'Adding bookmarks' do
  scenario 'User can add bookmarks' do
    visit('/bookmarks/new')
    expect(page).to have_content('new bookmark')
  end
end