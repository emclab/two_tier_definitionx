require 'spec_helper'

describe "LinkTests" do
  describe "GET /two_tier_definitionx_link_tests" do
    mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link'
        }
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      #@cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'module_category')
      
      user_access = FactoryGirl.create(:user_access, :action => 'index_project_status', :resource => 'two_tier_definitionx_definitions',  :role_definition_id => @role.id, :rank => 1,
        :sql_code => "TwoTierDefinitionx::Definition.scoped.order('id DESC')")     
      user_access = FactoryGirl.create(:user_access, :action => 'index_project_status', :resource => 'two_tier_definitionx_sub_definitions',  :role_definition_id => @role.id, :rank => 1,
        :sql_code => "TwoTierDefinitionx::SubDefinition.scoped.order('id DESC')")     
      user_access = FactoryGirl.create(:user_access, :action => 'create_project_status', :resource =>'two_tier_definitionx_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'update_project_status', :resource =>'two_tier_definitionx_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'show_project_status', :resource =>'two_tier_definitionx_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
      
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => @u.password
      click_button 'Login'
    end
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      sub = FactoryGirl.create(:two_tier_definitionx_sub_definition)
      qs = FactoryGirl.create(:two_tier_definitionx_definition, :active => true, :sub_definitions=> [sub], :last_updated_by_id => @u.id, :for_which => 'project_status')      
      #show
      visit definitions_path(for_which: 'project_status', subaction: 'project_status')
      click_link qs.name
      page.should have_content('Project Status Info')
      #sub definitions
      visit definitions_path(for_which: 'project_status', subaction: 'project_status')
      click_link 'Sub Definitions'
      #save_and_open_page
      page.should have_content('Sub Definitions')
      
      visit definitions_path(for_which: 'project_status', subaction: 'project_status')
      page.should have_content('Project Status')
      click_link 'Edit'
      page.should have_content('Update Project Status')
      fill_in :definition_name, :with => 'a new name'
      click_button 'Save'
      visit definitions_path(for_which: 'project_status', subaction: 'project_status')
      page.should have_content 'a new name'
      #bad data
      visit definitions_path(for_which: 'project_status', subaction: 'project_status')
      click_link 'Edit'
      fill_in :definition_name, :with => ''
      fill_in :definition_brief_note, :with => 'a bad input'
      click_button 'Save'
      visit definitions_path(for_which: 'project_status', subaction: 'project_status')
      page.should_not have_content 'a bad input'
      
      #new
      visit definitions_path(for_which: 'project_status', subaction: 'project_status')
      page.should have_content('Project Status')
      click_link 'New Project Status'
      page.should have_content('New Project Status')
      save_and_open_page
      fill_in :definition_name, :with => 'create new name'
      click_button 'Save'
      visit definitions_path(for_which: 'project_status', subaction: 'project_status')
      page.should have_content 'create new name'
      #bad data
      visit definitions_path(for_which: 'project_status', subaction: 'project_status')
      click_link 'New Project Status'
      fill_in :definition_name, :with => ''
      fill_in :definition_brief_note, :with => 'create bad input'
      click_button 'Save'
      visit definitions_path(for_which: 'project_status', subaction: 'project_status')
      page.should_not have_content 'create bad input'
      
    end
  end
end
