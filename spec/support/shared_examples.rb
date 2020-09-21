shared_examples_for "have user infomation" do
  it { expect(page).to have_text("#{@title}") }
  it { expect(page).to have_selector 'p', text: 'other_user.name' }
end