require 'rails_helper'

RSpec.feature "Following", type: :system do
  include_context "setup"

  let(:user){ create(:user) }
  let(:other_user){ create(:other_user) }
  # let(:users) { create_list(:other_user, 30) }

  describe "フォロー機能について" do
    before do
      sign_in user

      # users.each do |u|
      #   user.follow(u) #=> 自分が30人にフォローする
      #   u.follow(user) #=> 他人の30人からフォローされる
      # end

      # user.follow(other_user) #=> 自分が他人(1人)をにフォローする
      # other_user.follow(user) #=> 他人が自分(1人)をフォローする
    end

    # it { expect(user.following.count).to eq 31}
    # it { expect(other_user.following.count).to eq 1 }
    # it { expect(user.followers.count).to eq 31 }

    it "ユーザー詳細ページからフォロー可能" do
      visit user_path(other_user)
      click_button "Follow"
      expect(user.following.count).to eq 1

      visit following_user_path(user)
      expect(page).to have_content("Aliceさんがフォロー中")
      expect(page).to have_content("#{other_user.name}")
    end

    it

    it "フォロー一覧ページにフォロー中の方の名前が表示される" do
        before do
          sign_in user
        end
          it { expect(page).to have_text("#{@title}") }
          it { expect(page).to have_selector 'p', text: user.following.first.name }
    end

    it "フォロワー一覧ページにフォローされている方の名前が表示される" do
      before do
        sign_in user
        visit user_path(user)
        click_link "followers"
      end
      it { expect(page).to have_selector 'p', text: user.followers.first.name }
    end
  end
end