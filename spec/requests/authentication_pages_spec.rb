# frozen_string_literal: true

require "rails_helper"

describe "Authentication" do
  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_content("Sign In") }
    it { should have_title("Sign In") }

    describe "signin" do
      before { visit signin_path }

      describe "with invalid information" do
        before { click_button "Sign In" }

        it { should have_title("Sign In") }
        it { should have_selector("div.alert.alert-error", text: "Invalid") }
      end

      describe "with valid information" do
        let(:user) { FactoryGirl.create(:user) }
        before { sign_in user }

        it { should have_title user.name }
        it { should have_link "Profile",     href: user_path(user) }
        it { should have_link "Settings",    href: edit_user_path(user) }
        it { should have_link "Sign Out",    href: signout_path }
        it { is_expected.not_to have_link "Sign In", href: signin_path }
      end
    end
  end

  describe "authorization" do
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Relationships controller" do
        describe "submitting to the create action" do
          before { post relationships_path }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete relationship_path(1) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end # relationships controller

      describe "in the Users controller" do
        describe "visiting the following page" do
          before { visit following_user_path(user) }
          it { should have_title("Sign In") }
        end

        describe "visiting the followers page" do
          before { visit followers_user_path(user) }
          it { should have_title("Sign In") }
        end

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title "Sign In" }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title("Sign In") }
        end
      end # users controller

      describe "when attempting to visit a protected page" do
        before  do
          visit edit_user_path(user)
          fill_in "session_email", with: user.email
          fill_in "session_password", with: user.password
          click_button "Sign In"
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            expect(page).to have_title("Edit user")
          end
        end # visiting a protected page
      end

      describe "in the Squawks controller" do
        describe "submitting to the create action" do
          before { post squawks_path }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete squawk_path(FactoryGirl.create(:squawk)) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
    end # non-signed in

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) do
        FactoryGirl.create(:user, email: "wrong@example.com")
      end

      before { sign_in user, no_capybara: true }

      describe "submitting a GET request to the Users#edit action" do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title("Edit user")) }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end # wrong user

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin, no_capybara: true }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end # non-admin
  end # authorization
end # authentication
