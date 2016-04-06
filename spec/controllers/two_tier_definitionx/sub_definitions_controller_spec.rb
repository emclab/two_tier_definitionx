require 'rails_helper'

module TwoTierDefinitionx
  RSpec.describe SubDefinitionsController, type: :controller do
    routes {TwoTierDefinitionx::Engine.routes}
    before(:each) do
      expect(controller).to receive(:require_signin)
      #controller.should_receive(:require_employee)
    end
  
    render_views
    
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
       
      session[:user_role_ids] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id).user_role_ids
      session[:fort_token] = @u.fort_token
    end
    
    describe "GET 'index'" do
      it "returns all sub definitions" do       
        user_access = FactoryGirl.create(:user_access, :action => 'index_project_status', :resource => 'two_tier_definitionx_sub_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "TwoTierDefinitionx::SubDefinition.where(:active => true).order('ranking_index')")
        session[:employee] = true
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:two_tier_definitionx_definition, :active => true, :last_updated_by_id => @u.id, :for_which => 'project_status')
        sub1 = FactoryGirl.create(:two_tier_definitionx_sub_definition, :definition_id => qs.id, :name => 'new name', :active => true)
        sub2 = FactoryGirl.create(:two_tier_definitionx_sub_definition, :definition_id => qs.id + 1)
        get 'index' , {:definition_id => qs.id, :subaction => 'project_status'}
        #response.should be_success
        expect(assigns(:sub_definitions)).to match_array([sub1])
      end
      
    end
  
  end
end
