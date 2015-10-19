require 'spec_helper'

RSpec.feature 'posts' do
  let :post do
    posts :post
  end

  scenario 'listing all posts' do
    visit posts_path

    expect(page).to have_content 'Posts'
    expect(page).to have_content post.title
  end

  scenario 'showing a single post' do
    visit post_path(post)

    expect(page).to have_content post.title
    expect(page).to have_content post.body
  end

  scenario 'creating a new post' do
    skip
    visit new_post_path

    fill_in 'Title', with: 'new post'
    fill_in 'Body', with: 'this is a new post'
    click_button 'Save'

    expect(page).to have_content 'Listing Posts'
  end

  scenario 'editing an existing post' do
    skip
    visit edit_post_path(post)

    fill_in 'Title', with: 'new title'
    click_button 'Save'

    expect(page).to have_content 'new title'
  end

  scenario 'deleting an existing post' do
    visit posts_path(post, method: :delete)

    expect(page).to have_content 'Listing Posts'
  end
end
