require "rails_helper"

RSpec.describe CategoriesController, type: :controller do
  let!(:list_category) {FactoryBot.create_list :category, 3}

  describe "Not login" do
    context "GET #index" do
      before {get :index}

      it "redirect to login page" do
        expect(response).to redirect_to(login_path)
      end

      it "should found" do
        expect(response).to have_http_status(302)
      end
    end

    context "GET #new" do
      before {get :new}

      it "redirect to login page" do
        expect(response).to redirect_to(login_path)
      end

      it "should found" do
        expect(response).to have_http_status(302)
      end
    end

    context "POST #create" do
      before do
        post :create, params: {category: {name: "food"}}
      end

      it "redirect to login page" do
        expect(response).to redirect_to(login_path)
      end

      it "should found" do
        expect(response).to have_http_status(302)
      end
    end

    context "GET #edit" do
      before do
        get :edit, params: {id: 1}
      end

      it "redirect to login page" do
        expect(response).to redirect_to(login_path)
      end

      it "should found" do
        expect(response).to have_http_status(302)
      end
    end

    context "PATCH #update" do
      before do
        patch :update, params: {id: 1}
      end

      it "redirect to login page" do
        expect(response).to redirect_to(login_path)
      end

      it "should found" do
        expect(response).to have_http_status(302)
      end
    end

    context "DELETE #destroy" do
      before do
        delete :destroy, params: {id: 1}
      end

      it "redirect to login page" do
        expect(response).to redirect_to(login_path)
      end

      it "should found" do
        expect(response).to have_http_status(302)
      end
    end

    context "GET #sort" do
      before {get :sort}

      it "redirect to login page" do
        expect(response).to redirect_to(login_path)
      end

      it "should found" do
        expect(response).to have_http_status(302)
      end
    end

    context "GET #search" do
      before {get :search}

      it "redirect to login page" do
        expect(response).to redirect_to(login_path)
      end

      it "should found" do
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "login with admin", :order => :defined do
    before do
      @user = FactoryBot.create :user, role: 0
      @category = FactoryBot.create :category
    end

    context "GET #index" do
      before do
        log_in @user
        get :index
      end

      it "should be success" do
        expect(response).to have_http_status(200)
      end

      it "render index template" do
        expect(response).to render_template(:index)
      end

      it "assigns @categories" do
        expect(assigns(:categories)).to match_array(list_category)
      end
    end

    context "GET #new" do
      before do
        log_in @user
        get :new
      end

      it "should be success" do
        expect(response).to have_http_status(200)
      end

      it "render new template" do
        expect(response).to render_template(:new)
      end

      it "new category" do
        expect(assigns(:category)).to be_a_new(Category)
      end
    end

    context "POST #create" do
      before do
        puts "{post create before}"
        log_in @user
        post :create, params: {category: {name: "FFaker Category Name"}}
      end

      it "should found" do
        expect(response).to have_http_status(302)
      end

      it "redirect to category list" do
        expect(response).to redirect_to(categories_path)
      end

      it "create successfull" do
        expect(assigns(:category).name).to eq("FFaker Category Name")
      end
    end

    context "GET #edit" do
      before do
        log_in @user
        get :edit, params: {id: @category.id}
      end

      it "should be success" do
        expect(response).to have_http_status(200)
      end

      it "render to category new" do
        expect(response).to render_template(:edit)
      end
    end

    context "PATCH #update" do
      before do
        log_in @user
        patch :update, params: {id: @category.id, category: {name: "Fake_FreshFood"}}
      end

      it "should found" do
        expect(response).to have_http_status(302)
      end

      it "redirect to category list" do
        expect(response).to redirect_to(categories_path)
      end
    end

    context "DELETE #destroy" do
      before do
        log_in @user
        delete :destroy, params: {id: @category.id}
      end

      it "should found" do
        expect(response).to have_http_status(302)
      end

      it "redirect to category list" do
        expect(response).to redirect_to(categories_path)
      end
    end
  end
end
