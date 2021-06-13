require 'rails_helper'

RSpec.feature "Following", type: :system do
  let(:user){ create(:user) }
  let(:other_user){ create(:other_user) }

  describe "フォロー機能について" do
    context "フォローする場合" do
      let(:follow){ user.follow(other_user) }

      before do
        sign_in user
      end

      it "ユーザー詳細ページからフォロー可能、フォロー一覧にフォローしたユーザーが追加される" do
        visit user_path(other_user)
        click_button "Follow"

        visit following_user_path(user)
        expect(user.following.count).to eq 1

        expect(page).to have_content("Aliceさんがフォロー中")
        expect(page).to have_content("#{other_user.name}")
      end

      it "ユーザー詳細ページからフォロー解除可能、フォロー一覧からフォローしたユーザーが削除される" do
        follow
        visit user_path(other_user)
        click_button "Unfollow"

        visit following_user_path(user)
        expect(user.following.count).to eq 0

        expect(page).to have_content("Aliceさんがフォロー中")
        expect(page).to have_content("まだ誰もフォローしていません。")
        expect(page).to_not have_content("#{other_user.name}")
      end
    end

    context "フォローされる場合" do
      let!(:followed){ other_user.follow(user)}

      it "フォロワー一覧ページにフォローしたユーザーが追加される" do
        sign_in user
        visit followers_user_path(user)
        expect(user.followers.count).to eq 1

        expect(page).to have_content("Aliceさんのフォロワー")
        expect(page).to have_content("#{other_user.name}")
      end

      it "フォロワー一覧ページにフォローしたユーザーが削除される" do
        sign_in other_user
        visit user_path(user)
        click_button "Unfollow"

        visit followers_user_path(user)
        expect(user.followers.count).to eq 0

        expect(page).to have_content("Aliceさんのフォロワー")
        expect(page).to have_content("まだ誰からもフォローされていません。")
        expect(page).to_not have_content("#{other_user.name}")
      end
    end
  end
end