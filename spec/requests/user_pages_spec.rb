describe "User Pages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }
    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: full_title("Sign up")) }
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    it { should have_selector('h1',    text: user.name) }
    it { should have_selector('title', text: user.name) }
  end

  describe "signup" do

    before { visit signup_path }
    let(:submit) { "Create my account" }

    describe "with invalid information" do

      describe "after submission" do
        before { click_button submit }

        it { should have_selector("title", text: "Sign up") }
        it { should have_content("error") }
      end

      describe "when password is less than 6 characters" do
        before do
          fill_in "Name",         with: "Example User"
          fill_in "Email",        with: "example@user.com"
          fill_in "Password",     with: "foob1"
          fill_in "Confirmation", with: "foob1"        
          click_button submit
        end

        let(:str) { "Password is too short (minimum is 6 characters)" }
        it { should have_selector("title", text: "Sign up") }
        it { should have_content(str) }
      end

      describe "when password & confirmation mismatch" do
        before do
          fill_in "Name",         with: "Example User"
          fill_in "Email",        with: "example@user.com"
          fill_in "Password",     with: "foobar1"
          fill_in "Confirmation", with: "fooar1" 
          click_button submit
        end

        let(:str) { "Password doesn't match confirmation" }
        it { should have_selector("title", text: "Sign up") }
        it { should have_content(str) }
      end


      describe "when email format is invalid" do
        before do
          fill_in "Name",         with: "Example User"
          fill_in "Email",        with: "exampleuser.com"
          fill_in "Password",     with: "foob1"
          fill_in "Confirmation", with: "foob1"        
          click_button submit
        end

        let(:str) { "Email is invalid" }
        it { should have_selector("title", text: "Sign up") }
        it { should have_content(str) }
      end

      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      describe "increases User count by one" do
        before do
            fill_in "Name",         with: "Example User"
            fill_in "Email",        with: "example@user.com"
            fill_in "Password",     with: "foobar"
            fill_in "Confirmation", with: "foobar"
        end

          it "should create and save user and go to user profile" do
            expect { click_button submit }.to change(User, :count).by(1)
          end
      end

      describe "creates new user and goes to profile" do
        before do
          fill_in "Name",         with: "Example User"
          fill_in "Email",        with: "ExamPLe@user.Com"
          fill_in "Password",     with: "foobar"
          fill_in "Confirmation", with: "foobar"
          click_button submit
        end
      
        let(:user) { User.find_by_email("example@user.com") }
        it { should have_selector("title", text: user.name) }
        it { should have_selector("div.alert.alert-success", text: "Welcome") }
      end
    end
  end
end