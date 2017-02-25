#require 'rails_helper'
#
#RSpec.describe PostsController, type: :controller do
# 
#  describe "Get #index" do 
#
#    
#
#    it "responds successfuly with an HTTP 200 status code" do   
#
#      get :index
#  
#        expect(response).to be_success
#        expect(response).to have_http_status(200)
#    
#    end
#
#    it "renders the index template" do
#
#        get :index
#      
#        expect(response).to render_template("index")
#
#    end
#
#    context "Model interactions: checks that items assigned to the instance variable" do
#      
#        let(:post) do create(:post) end
#
#        it "loads posts into @posts" do
#
#          get :index 
#
#          expect(assigns(:posts)).to match_array([post])
#
#        end
#
#        it "gets user" do 
#
#            expect(Post).to receive(:user).with('user_id')
#            get :index
#
#        end
#
#      end
#
#  end
#
#end


 