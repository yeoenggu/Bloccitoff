require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe ItemsController, type: :controller do

  describe "POST #create" do

    context "with valid params" do

      it "creates a new Item" do

        user = create(:user)

        valid_task_name = "To do it"
        invalid_task_name = "Do it later"

        valid_attributes = { name: valid_task_name, user_id: user.id }
        invalid_attributes = { name: invalid_task_name }
        valid_session ={ name: valid_task_name, user_id: user.id }

        expect {
          post :create, {item: valid_attributes}, valid_session
        }.to change(Item, :count).by(1)
      end

      it "assigns a newly created item as @item" do
        user = create(:user)

        valid_task_name = "To do it"
        invalid_task_name = "Do it later"

        valid_attributes = { name: valid_task_name, user_id: user.id }
        invalid_attributes = { name: invalid_task_name }
        valid_session ={ name: valid_task_name, user_id: user.id }

        post :create, {:item => valid_attributes}, valid_session
        expect(assigns(:item)).to be_a(Item)
        expect(assigns(:item)).to be_persisted
      end

      it "redirects to the created item" do
        user = create(:user)

        valid_task_name = "To do it"
        invalid_task_name = "Do it later"

        valid_attributes = { name: valid_task_name, user_id: user.id }
        invalid_attributes = { name: invalid_task_name }
        valid_session ={ name: valid_task_name, user_id: user.id }

        post :create, {:item => valid_attributes}, valid_session
        expect(response).to redirect_to(Item.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved item as @item" do
        
        user = build(:user)
        user.save
        valid_task_name = "To do it"
        invalid_task_name = "Do it later"

        valid_attributes = { name: valid_task_name, user_id: user.id }
        invalid_attributes = { name: invalid_task_name }
        valid_session ={ name: valid_task_name, user_id: user.id }

        post :create, {:item => invalid_attributes}, valid_session
        expect(assigns(:item)).to be_a_new(Item)
      end

      it "re-renders the 'new' template" do
        user = build(:user)
        user.save
        valid_task_name = "To do it"
        invalid_task_name = "Do it later"

        valid_attributes = { name: valid_task_name, user_id: user.id }
        invalid_attributes = { name: invalid_task_name }
        valid_session ={ name: valid_task_name, user_id: user.id }

        post :create, {:item => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

end
