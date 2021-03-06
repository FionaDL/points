require 'rails_helper'
require 'apparition_helper'

RSpec.describe 'managing stories', js: !ENV['CI'] do

  let(:user) {FactoryBot.create(:user)}
  let(:project) {FactoryBot.create(:project)}
  let!(:story) {FactoryBot.create(:story, project: project)}

  before do
    login_as(user, scope: :user)
  end

  it "allows me to add a story" do
    visit project_path(id: project.id)
    click_link "Add a Story"
    fill_in "story[title]", with: "As a user, I want to add stories"
    fill_in "story[description]", with: "This story allows users to add stories."
    click_button "Create"
    expect(Story.count).to eq 2
  end

  it "allows me to clone a story" do
    visit project_path(id: project.id)
    within("#story_#{story.id}") {click_link 'Clone'}
    expect(page.find("#story_title").value).to eq story.title
    expect(page.find("#story_description").value).to eq story.description
    click_button 'Create'
    expect(Story.count).to eq 2
  end

  it "allows me to edit a story" do
    visit project_path(id: project.id)
    click_link "Edit"
    fill_in "story[title]", with: "As a user, I want to edit stories"
    click_button "Save Changes"
    expect(page).to have_content "Story updated!"
  end

  it "allows me to delete a story" do
    visit project_path(id: project.id)
    click_link "Delete"
    expect(Story.count).to eq 0
  end
end
