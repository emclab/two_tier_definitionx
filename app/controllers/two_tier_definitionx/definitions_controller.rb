require_dependency "two_tier_definitionx/application_controller"

module TwoTierDefinitionx
  class DefinitionsController < ApplicationController
    #before_filter :require_employee
    before_filter :load_for_which, :only => [:index, :new, :edit, :show] 
    after_action :info_logger, :except => [:new, :edit, :event_action_result, :wf_edit_result, :search_results, :stats_results, :acct_summary_result]
    
    def index
      @title = t(@for_which.sub('_', ' ').pluralize.titleize)  #ex, Quality Systems
      @definitions = params[:two_tier_definitionx_definitions][:model_ar_r]
      @definitions = @definitions.where(:for_which => @for_which)
      @definitions = @definitions.page(params[:page]).per_page(@max_pagination).order('ranking_index')
      @erb_code = find_config_const('definition_index_view', session[:fort_token], 'two_tier_definitionx')     
    end
  
    def new
      @title = t("New " + @for_which.sub('_', ' ').titleize)  #ex, New Quality System
      @definition = TwoTierDefinitionx::Definition.new()
      @definition.sub_definitions.build
      @erb_code = find_config_const('definition_new_view', session[:fort_token], 'two_tier_definitionx')  
      @erb_code_field = find_config_const('definition_new_view_field', session[:fort_token], 'two_tier_definitionx') 
    end
  
    def create
      @definition = TwoTierDefinitionx::Definition.new(new_params)
      @definition.fort_token = session[:fort_token]
      @definition.last_updated_by_id = session[:user_id]
      fill_in_token()
      if @definition.save
        redirect_to definitions_path(:for_which => @definition.for_which, :subaction => @definition.for_which), :notice => t("Definition Saved!")
      else
        @for_which = params[:definition][:for_which]
        @erb_code = find_config_const('definition_new_view', session[:fort_token], 'two_tier_definitionx')  
        @erb_code_field = find_config_const('definition_new_view_field', session[:fort_token], 'two_tier_definitionx') 
        flash.now[:error] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = t("Update " + @for_which.sub('_', ' ').titleize)
      @definition = TwoTierDefinitionx::Definition.find(params[:id])
      @erb_code = find_config_const('definition_edit_view', session[:fort_token], 'two_tier_definitionx')  
      @erb_code_field = find_config_const('definition_new_view_field', session[:fort_token], 'two_tier_definitionx') 
    end
  
    def update
      @definition = TwoTierDefinitionx::Definition.find(params[:id])
      @definition.last_updated_by_id = session[:user_id]
      if @definition.update_attributes(edit_params)
        redirect_to definitions_path(:for_which => @definition.for_which, :subaction => @definition.for_which), :notice => t("Definition Updated!")
      else
        @for_which = TwoTierDefinitionx::Definition.find(params[:id]).for_which
        @erb_code = find_config_const('definition_update_view', session[:fort_token], 'two_tier_definitionx')  
        @erb_code_field = find_config_const('definition_new_view_field', session[:fort_token], 'two_tier_definitionx')   
        flash.now[:error] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
    
    def show
      @title = t(@for_which.sub('_', ' ').titleize + ' Info')
      @definition = TwoTierDefinitionx::Definition.find(params[:id])
      @erb_code = find_config_const('definition_show_view', session[:fort_token], 'two_tier_definitionx')  
    end
  
    protected
    
    def load_for_which     
      @for_which = params[:for_which].strip if params[:for_which].present?
      @for_which = TwoTierDefinitionx::Definition.find_by_id(params[:id]).for_which if params[:id].present?
      if @for_which.blank?
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=NO Subaction in Definition!") 
      end
    end
    
    def fill_in_token
      @definition.sub_definitions.each do |r|
        r.fort_token = session[:fort_token]
      end
    end
    
    private
    
    def new_params
      params.require(:definition).permit(:active, :brief_note, :for_which, :last_updated_by_id, :name, :ranking_index, 
                                         :sub_definitions_attributes => [:name, :ranking_index, :brief_note, :id, :_destroy])
    end
    
    def edit_params
      params.require(:definition).permit(:active, :brief_note, :for_which, :last_updated_by_id, :name, :ranking_index, 
                                         :sub_definitions_attributes => [:name, :ranking_index, :active, :brief_note, :id, :_destroy])
    end
  end
end
