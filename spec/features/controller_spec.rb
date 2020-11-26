feature 'Page shows Hello World' do
  scenario 'shows Hello World' do
    visit('/')
    expect(page).to have_content 'Hello World'
  end
end
