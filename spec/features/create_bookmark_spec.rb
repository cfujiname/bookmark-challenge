feature 'Adding bookmarks' do
  scenario 'User can add bookmarks' do
    visit('/bookmarks/new')
    fill_in('url', with: 'http://www.gmail.com')
    fill_in('title', with: 'Gmail')
    click_button('Submit')
    expect(page).to have_link('Gmail', href: 'http://www.gmail.com')
  end

  scenario 'Bookmark must be a valid url' do
    visit('bookmarks/new')
    fill_in('url', with: 'this is not a url')
    click_button('Submit')
    expect(page).not_to have_content 'this is not a url' 
    expect(page).to have_link 'You must sumbit a valid url'
  end
end