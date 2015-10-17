require 'spec_helper'

RSpec.feature 'posts' do
  let :post do
    posts :existing_post
  end

  scenario 'listing all posts' do
    visit posts_path

    expect(response).to be_success
    expect(page).to have_content 'Posts'
    expect(page).to have_content post.title
  end

  scenario 'showing a single post' do
    visit post_path(post)

    expect(response).to be_success
    expect(page).to have_content post.title
    expect(page).to have_content post.body
  end

  scenario 'creating a new post' do
    visit new_post_path

    expect(response).to be_success
    fill_in 'Title', with: 'new post'
    fill_in 'body', with: 'this is a new post'
    click_button 'Save'

    expect(response).to be_redirect
    expect(page).to have_content 'Post created'
  end

  scenario 'editing an existing post' do
    visit edit_post_path(post)

    expect(response).to be_success
    fill_in 'Title', with: 'new title'
    click_button 'Save'

    expect(response).to be_redirect
    expect(page).to have_content 'Post saved'
    expect(page).to have_content 'new title'
  end

  scenario 'deleting an existing post' do
    visit posts_path(post, method: :delete)

    expect(response).to be_redirect
    expect(page).to have_content 'Post destroyed'
  end
end
