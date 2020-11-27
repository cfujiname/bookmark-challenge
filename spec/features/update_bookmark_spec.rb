feature ' Update bookmarks' do
  it 'User can update bookmark url and title' do
    bookmark = Bookmark.create(url: 'http://www.hello.com', title: 'hello')
    visit('/bookmarks')
    expect(page).to have_link('hello', href: 'http://www.hello.com')

    first('.bookmark').click_button 'Edit'
    
    expect(current_path).to eq "/bookmarks/#{bookmark.id}/edit"
    fill_in('url', with: 'http://www.goodbye.com')
    fill_in('title', with: 'goodbye')
    click_button('Submit')
    expect(current_path).to eq '/bookmarks'
    expect(page).not_to have_link('hello', href: 'http://www.hello.com')
    expect(page).to have_link('goodbye', href: 'http://www.goodbye.com')
  end
end