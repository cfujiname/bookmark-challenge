feature 'Add and view comments' do
  scenario 'User can add and view comments' do
    bookmark = Bookmark.create(url: 'http://www.pupa.com', title: 'Pupa')
    visit('/bookmarks')
    first('.bookmark').click_button 'Add Comment'
    expect(current_path).to eq "/bookmarks/#{bookmark.id}/comments/new"
    fill_in('comment', with: 'This is a test comment for this specific bookmark')
    click_button('Submit')
    expect(current_path).to eq '/bookmarks'
    expect(first('.bookmark')).to have_content 'This is a test comment for this specific bookmark'
  end
end