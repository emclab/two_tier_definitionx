require_dependency "two_tier_definitionx/application_controller"

module TwoTierDefinitionx
  class DefinitionsController < ApplicationController
    #before_filter :require_employee
    before_filter :load_for_which, :only => [:index, :new, :edit, :show] 
    
    def index
      @title = @for_which.sub('_', ' ').pluralize.titleize  #ex, Quality Systems
      @definitions = params[:two_tier_definitionx_definitions][:model_ar_r]
      @definitions = @definitions.where(:for_which => @for_which)
      @definitions = @definitions.page(params[:page]).per_page(@max_pagination).order('ranking_index')
      @erb_code = find_config_const('definition_index_view', 'two_tier_definitionx')     
    end
  
    def new
      @title = "New " + @for_which.sub('_', ' ').titleize  #ex, New Quality System
      @definition = TwoTierDefinitionx::Definition.new()
      @definition.sub_definitions.build
      @erb_code = find_config_const('definition_new_view', 'two_tier_definitionx')  
      @erb_code_field = find_config_const('definition_new_view_field', 'two_tier_definitionx') 
    end
  
    def create
      @definition = TwoTierDefinitionx::Definition.new(params[:definition], :as => :role_new)
      @definition.last_updated_by_id = session[:user_id]
      if @definition.save
        redirect_to definitions_path(:for_which => @definition.for_which, :subaction => @definition.for_which), :notice => t("Definition Saved!")
      else
        @for_which = params[:definition][:for_which]
        @erb_code = find_config_const('definition_new_view', 'two_tier_definitionx')  
        @erb_code_field = find_config_const('definition_new_view_field', 'two_tier_definitionx') 
        flash.now[:error] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = "Update " + @for_which.sub('_', ' ').titleize
      @definition = TwoTierDefinitionx::Definition.find(params[:id])
      @erb_code = find_config_const('definition_update_view', 'two_tier_definitionx')  
      @erb_code_field = find_config_const('definition_new_view_field', 'two_tier_definitionx') 
    end
  
    def update
      @definition = TwoTierDefinitionx::Definition.find(params[:id])
      @definition.last_updated_by_id = session[:user_id]
      if @definition.update_attributes(params[:definition], :as => :role_update)
        redirect_to definitions_path(:for_which => @definition.for_which, :subaction => @definition.for_which), :notice => t("Definition Updated!")
      else
        @for_which = TwoTierDefinitionx::Definition.find(params[:id]).for_which
        @erb_code = find_config_const('definition_update_view', 'two_tier_definitionx')  
        @erb_code_field = find_config_const('definition_new_view_field', 'two_tier_definitionx')   
        flash.now[:error] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
    
    def show
      @title = t(@for_which.sub('_', ' ').titleize + ' Info')
      @definition = TwoTierDefinitionx::Definition.find(params[:id])
      @erb_code = find_config_const('definition_show_view', 'two_tier_definitionx')  
    end
  
    protected
    
    def load_for_which     
      @for_which = params[:for_which].strip if params[:for_which].present?
      @for_which = TwoTierDefinitionx::Definition.find_by_id(params[:id]).for_which if params[:id].present?
      if @for_which.blank?
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO Subaction in Definition!") 
      end
    end
  end
end
