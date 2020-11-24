feature 'Page shows Hello World' do
  scenario 'shows Hello World' do
    visit('/')
    expect(page).to have_content 'Hello World'
  end
end

feature 'Page shows all bookmarks' do
  scenario 'show list of bookmarks' do
    visit('/bookmarks')
    expect(page).to have_content 'List of all bookmarks'
  end
end