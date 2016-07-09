require 'spec_helper'

RSpec.feature 'posts' do
  fixtures :posts

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
    visit new_post_path

    fill_in 'Title', with: 'new post'
    fill_in 'Body', with: 'this is a new post'
    click_button 'Save'

    expect(page).to have_content 'Post created.'
    expect(page).to have_content 'Title: new post'
  end

  scenario 'editing an existing post' do
    visit edit_post_path(post)

    fill_in 'Title', with: 'new title'
    click_button 'Save'

    expect(page).to have_content 'Post updated.'
    expect(page).to have_content 'Title: new title'
  end

  scenario 'deleting an existing post' do
    visit posts_path

    within "#post-#{post.id}" do
      click_link 'Destroy'
    end

    expect(page).to have_content 'Post deleted'
    expect(page).not_to have_content post.title
  end
end
