feature 'Adding bookmarks' do
  scenario 'User can add bookmarks' do
    visit('/bookmarks/new')
    fill_in('url', with: 'http://www.gmail.com')
    fill_in('title', with: 'Gmail')
    click_button('Submit')
    expect(page).to have_link('Gmail', href: 'http://www.gmail.com')
  end
end