feature 'view bookmarks' do
  scenario 'bookmarks with title and link are visible' do
    Bookmark.create(url: "http://www.destroyallsoftware.com", title: "DAS")
    Bookmark.create(url: "http://www.google.com", title: "Google")
    visit '/bookmarks'
    expect(page).to have_link('DAS', href: 'http://www.destroyallsoftware.com')
    expect(page).to have_link('Google', href: 'http://www.google.com')
  end
end