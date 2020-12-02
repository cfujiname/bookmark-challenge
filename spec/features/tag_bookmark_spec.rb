feature 'Add and viewing tags' do
  feature 'User can add new tag' do 
    scenario 'a tag is added to a bookmark' do
      bookmark = Bookmark.create(url: 'http://www.inalina.com', title: 'Ina bonoba')
      visit '/bookmarks'
      first('.bookmark').click_button 'Add Tag'
      expect(current_path).to eq "/bookmarks/#{bookmark.id}/tags/new"
      fill_in 'tag', with: 'test tag'
      click_button 'Submit'
      expect(current_path).to eq '/bookmarks'
      expect(first('.bookmark')).to have_content 'test tag'
    end
  end
end