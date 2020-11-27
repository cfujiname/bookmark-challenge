feature 'delete a bookmark' do
  scenario 'User can delete bookmark' do
    Bookmark.create(url: 'http://www.hello.com', title: 'hello')
    visit('/bookmarks')
    expect(page).to have_link('hello', href: 'http://www.hello.com')
    first('.bookmark').click_button 'Delete'
    expect(current_path).to eq '/bookmarks'
    expect(page).not_to have_link('hello', href: 'http://www.hello.com')
  end
end