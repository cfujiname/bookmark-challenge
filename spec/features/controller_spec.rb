feature 'Page shows Bookmark Manager' do
  scenario 'shows Bookmark Manager' do
    visit('/')
    expect(page).to have_content 'Bookmark Manager'
  end
end
