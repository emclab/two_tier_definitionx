require_dependency "two_tier_definitionx/application_controller"

module TwoTierDefinitionx
  class SubDefinitionsController < ApplicationController
    protect_from_forgery with: :exception, except: [:new, :edit]
    before_filter :load_record
    after_action :info_logger, :except => [:new, :edit, :event_action_result, :wf_edit_result, :search_results, :stats_results, :acct_summary_result]
    
    def index
      @title = I18n.t(@definition.for_which.titleize) + ' - ' + I18n.t('Sub Definitions') #ex, Quality System - Sub Definitions
      @sub_definitions = params[:two_tier_definitionx_sub_definitions][:model_ar_r]
      @sub_definitions = @definition.sub_definitions if @definition
      @sub_definitions = @sub_definitions.page(params[:page]).per_page(@max_pagination).order('ranking_index')  
      @erb_code = find_config_const('sub_definition_index_view', session[:fort_token], 'two_tier_definitionx')     
    end
    
    def new
      @sub_definition = TwoTierDefinitionx::SubDefinition.new()
    end
    
    def create
      @sub_definition = TwoTierDefinitionx::SubDefinition.new(new_params)
      #@sub_definition.last_updated_by_id = session[:user_id]
      @sub_definition.fort_token = session[:fort_token] 
      if @sub_definition.save
        redirect_to sub_definitions_path(:definition_id => @sub_definition.definition_id, :subaction => @sub_definition.definition.for_which), :notice => t("Definition Saved!")
      else
        @definition = TwoTierDefinitionx::Definition.find_by_id(@sub_definition.definition_id)
        flash.now[:error] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
    
    def edit
      @sub_definition = TwoTierDefinitionx::SubDefinition.find_by_id(params[:id])
    end
    
    def update
      @sub_definition = TwoTierDefinitionx::SubDefinition.find_by_id(params[:id])
      #@sub_definition.last_updated_by_id = session[:user_id]
      if @sub_definition.update_attributes(edit_params)
        redirect_to sub_definitions_path(:definition_id => @sub_definition.definition_id, :subaction => @sub_definition.definition.for_which), :notice => t("Definition Updated!")
      else
        flash.now[:error] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
    
    protected
    def load_record
      @definition = TwoTierDefinitionx::Definition.find_by_id(params[:definition_id]) if params[:definition_id].present?
    end
    
    private
    
    def new_params
      params.require(:sub_definition).permit(:active, :brief_note, :definition_id, :name, :ranking_index)
    end
    
    def edit_params
      params.require(:sub_definition).permit(:active, :brief_note, :name, :ranking_index)
    end
    
  end
end
