require 'rails_helper'

module TwoTierDefinitionx
  RSpec.describe DefinitionsController, type: :controller do
    routes {TwoTierDefinitionx::Engine.routes}
    before(:each) do
      expect(controller).to receive(:require_signin)
      #controller.should_receive(:require_employee)
    end
  
    render_views
    
    before(:each) do
      FactoryGirl.create(:engine_config, :engine_name => 'rails_app', :engine_version => nil, :argument_name => 'enable_info_logger', :argument_value => 'true')
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
      it "returns project status for user" do       
        user_access = FactoryGirl.create(:user_access, :action => 'index_project_status', :resource => 'two_tier_definitionx_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "TwoTierDefinitionx::Definition.where(:active => true).where('for_which = ?', 'project_status').order('ranking_index')")
        session[:employee] = true
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:two_tier_definitionx_definition, :active => true, :last_updated_by_id => @u.id, :for_which => 'project_status')
        get 'index' , {:for_which => qs.for_which, :subaction => qs.for_which}
        #expect(response).to be_success
        expect(assigns(:definitions)).to match_array([qs])
      end
      
      it "returns project status for user" do
        user_access = FactoryGirl.create(:user_access, :action => 'index_project_status', :resource => 'two_tier_definitionx_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "TwoTierDefinitionx::Definition.where(:active => true).order('ranking_index')")
        session[:employee] = true
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:two_tier_definitionx_definition, :active => true, :last_updated_by_id => @u.id, :for_which => 'project_status')
        get 'index' , {:for_which => 'project_status', :subaction => 'project_status'}
        #expect(response).to be_success
        expect(assigns(:definitions)).to match_array([qs])
      end
      
      it "should redirect if no for_which passed in" do
        user_access = FactoryGirl.create(:user_access, :action => 'index_task_status', :resource => 'two_tier_definitionx_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "TwoTierDefinitionx::Definition.where(:active => true).order('ranking_index')")
        session[:employee] = true
        session[:user_id] = @u.id
        ls = FactoryGirl.create(:two_tier_definitionx_definition, :active => true, :last_updated_by_id => @u.id, :for_which => 'task_status')
        get 'index' , {:for_which => nil, :subaction => 'task_status'}
        expect(response).to redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=NO Subaction in Definition!") 
      end
      
    end
  
    describe "GET 'new'" do
      it "returns http success for project status with create action rights" do
        user_access = FactoryGirl.create(:user_access, :action => 'create_project_status', :resource => 'two_tier_definitionx_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        get 'new', {:for_which => 'project_status', :subaction => 'project_status'}
        expect(response).to be_success
      end
      
      it "returns http success for task_status with create action rights" do
        user_access = FactoryGirl.create(:user_access, :action => 'create_task_status', :resource => 'two_tier_definitionx_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        get 'new', {:for_which => 'task_status', :subaction => 'task_status'}
        expect(response).to be_success
      end
      
    end
  
    describe "GET 'create'" do
      it "should save for proj status with create right" do
        user_access = FactoryGirl.create(:user_access, :action => 'create_project_status', :resource => 'two_tier_definitionx_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:subaction] = 'project_status'
        sub = FactoryGirl.attributes_for(:two_tier_definitionx_sub_definition)
        qs = FactoryGirl.attributes_for(:two_tier_definitionx_definition, :for_which => 'project_status', :sub_definitions_attributes => [sub])
        get 'create', {:definition => qs, :for_which => 'project_status'}   #:subaction => 'project_status' handled by session variable.
        expect(response).to redirect_to definitions_path(:for_which => 'project_status', :subaction => 'project_status')
      end
      
      it "should save for task_status with create right" do
        user_access = FactoryGirl.create(:user_access, :action => 'create_task_status', :resource => 'two_tier_definitionx_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:subaction] = 'task_status'
        sub = FactoryGirl.attributes_for(:two_tier_definitionx_sub_definition)
        qs = FactoryGirl.attributes_for(:two_tier_definitionx_definition, :for_which => 'task_status', :sub_definitions_attributes => [sub])
        get 'create', {:definition => qs, :for_which => 'project_status'}  # :subaction => 'task_status'}
        expect(response).to redirect_to definitions_path(:for_which => 'task_status', :subaction => 'task_status')
      end
      
      it "should render new with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create_project_status', :resource => 'two_tier_definitionx_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:subaction] = 'project_status'
        sub = FactoryGirl.attributes_for(:two_tier_definitionx_sub_definition)
        qs = FactoryGirl.attributes_for(:two_tier_definitionx_definition, :name => nil, :for_which => 'project_status', :sub_definitions_attributes => [sub])
        get 'create', {:definition => qs, :for_which => 'project_status', :subaction => 'project_status'}
        expect(response).to render_template('new')
      end
      
    end
  
    describe "GET 'edit'" do
      it "should edit project_status with proper right" do
        user_access = FactoryGirl.create(:user_access, :action => 'update_project_status', :resource => 'two_tier_definitionx_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:two_tier_definitionx_definition, :for_which => 'project_status')
        get 'edit', {:id => qs.id, :for_which => 'project_status', :subaction => 'project_status'}
        expect(response).to be_success
      end
      
      it "should edit task_status with proper right" do
        user_access = FactoryGirl.create(:user_access, :action => 'update_task_status', :resource => 'two_tier_definitionx_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:two_tier_definitionx_definition, :for_which => 'task_status')
        get 'edit', {:id => qs.id, :for_which => 'task_status', :subaction => 'task_status'}
        expect(response).to be_success
      end
      
    end
  
    describe "GET 'update'" do
      it "should update with update right" do
        user_access = FactoryGirl.create(:user_access, :action => 'update_project_status', :resource => 'two_tier_definitionx_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:subaction] = 'project_status'
        qs = FactoryGirl.create(:two_tier_definitionx_definition, :for_which => 'project_status')
        get 'update', {:id => qs.id, :definition => {:name => 'newnew name'}, :for_which => 'project_status'}
        expect(response).to redirect_to definitions_path(:for_which => 'project_status', :subaction => 'project_status')
      end
      
      it "should update task_status with update right" do
        user_access = FactoryGirl.create(:user_access, :action => 'update_task_status', :resource => 'two_tier_definitionx_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:subaction] = 'task_status'
        qs = FactoryGirl.create(:two_tier_definitionx_definition, :for_which => 'task_status')
        get 'update', {:id => qs.id, :definition => {:name => 'newnew name'}, :for_which => 'task_status'}
        expect(response).to redirect_to definitions_path(:for_which => 'task_status', :subaction => 'task_status')
      end
      
      it "should render edit with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update_task_status', :resource => 'two_tier_definitionx_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:subaction] = 'task_status'
        qs = FactoryGirl.create(:two_tier_definitionx_definition, :for_which => 'task_status')
        get 'update', {:id => qs.id, :definition => {:name => ''}, :for_which => 'task_status', :subaction => 'task_status'}
        expect(response).to render_template('edit')
      end
    end
    
    describe "GET 'show'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'show_task_status', :resource => 'two_tier_definitionx_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:subaction] = 'task_status'
        qs = FactoryGirl.create(:two_tier_definitionx_definition, :for_which => 'task_status')
        get 'show', {:id => qs.id, :subaction => 'task_status'}
        expect(response).to be_success
      end
    end
  
  end
end
