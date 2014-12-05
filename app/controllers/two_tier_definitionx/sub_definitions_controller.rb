require_dependency "two_tier_definitionx/application_controller"

module TwoTierDefinitionx
  class SubDefinitionsController < ApplicationController
    before_filter :load_record
    
    def index
      @title = I18n.t(@definition.for_which.titleize) + ' - ' + I18n.t('Sub Definitions') #ex, Quality System - Sub Definitions
      @sub_definitions = params[:two_tier_definitionx_sub_definitions][:model_ar_r]
      @sub_definitions = @definition.sub_definitions if @definition
      @sub_definitions = @sub_definitions.page(params[:page]).per_page(@max_pagination).order('ranking_index')  
      @erb_code = find_config_const('sub_definition_index_view', 'two_tier_definitionx')     
    end
    
    protected
    def load_record
      @definition = TwoTierDefinitionx::Definition.find_by_id(params[:definition_id]) if params[:definition_id].present?
    end
  end
end
