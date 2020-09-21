require 'rails_helper'

RSpec.feature "UsersFollowing", type: :system do
  include_context "setup"

  let(:user){ create(:user) }
  let(:other_user){ create(:other_user) }

  describe "following/followers method" do
    before do
      users
      users.each do |u|
        user.follow(u) #=> 自分が30人にフォローする
        u.follow(user) #=> 他人の30人からフォローされる
      end

      user.follow(other_user) #=> 自分が他人(1人)をにフォローする
      other_user.follow(user) #=> 他人が自分(1人)をフォローする
    end

    it { expect(user.following.count).to eq 31}
    it { expect(other_user.following.count).to eq 1 }
    it { expect(user.followers.count).to eq 31 }

    describe "following/follower page" do
      context "フォロー中の方の名前表示" do
        before do
          sign_in user
          visit user_path(user)
          click_link "following"
        end
          it { expect(page).to have_text("#{@title}") }
          it { expect(page).to have_selector 'p', text: user.following.first.name }
      end

      context "フォロワーの方の名前表示" do
        before do
          sign_in user
          visit user_path(user)
          click_link "followers"
        end
          it { expect(page).to have_text("#{@title}") }
          it { expect(page).to have_selector 'p', text: user.followers.first.name }
      end
    end
  end
end