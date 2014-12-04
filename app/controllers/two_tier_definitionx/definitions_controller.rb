require_dependency "two_tier_definitionx/application_controller"

module TwoTierDefinitionx
  class DefinitionsController < ApplicationController
    before_filter :require_employee
    before_filter :load_for_which, :only => [:index, :new, :edit]  
    before_filter :load_session_variable, :only => [:new, :edit]  #for subaction in check_access_right
    after_filter :delete_session_variable, :only => [:create, :update]   #for subaction in check_access_right
    
    def index
      @title = @for_which.sub('_', ' ').pluralize.titleize  #ex, Quality Systems
      @definitions = params[:two_tier_definitionx_definitions][:model_ar_r]
      @definitions = @definitions.where(:for_which => @for_which)
      @definitions = @definitions.page(params[:page]).per_page(@max_pagination).order('ranking_index')     
    end
  
    def new
      @title = "New " + @for_which.sub('_', ' ').titleize  #ex, New Quality System
      @definition = TwoTierDefinition::Definition.new()
      @definition.sub_definitions.build
    end
  
    def create
      @definition = TwoTierDefinition::Definition.new(params[:definition], :as => :role_new)
      @definition.last_updated_by_id = session[:user_id]
      if @definition.save
        redirect_to misc_definitions_path(:for_which => @definition.for_which, :subaction => @definition.for_which), :notice => t("Definition Saved!")
      else
        @for_which = params[:definition][:for_which]
        flash.now[:error] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = "Update " + @for_which.sub('_', ' ').titleize
      @definition = TwoTierDefinition::Definition.find(params[:id])
    end
  
    def update
      @definition = TwoTierDefinition::Definition.find(params[:id])
      @definition.last_updated_by_id = session[:user_id]
      if @definition.update_attributes(params[:definition], :as => :role_update)
        redirect_to definitions_path(:for_which => @definition.for_which, :subaction => @definition.for_which), :notice => t("Definition Updated!")
      else
        @for_which = TwoTierDefinition::Definition.find(params[:id]).for_which  
        flash.now[:error] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
    
    def show
      @title = t(@for_which.sub('_', ' ').titleize + ' Info')
      @definition = TwoTierDefinition::Definition.find(params[:id])
    end
  
    protected
    
    def load_for_which     
      @for_which = params[:for_which].strip if params[:for_which].present?
      @for_which = TwoTierDefinition::Definition.find_by_id(params[:id]).for_which if params[:id].present?
      if @for_which.blank?
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO Subaction in Misc Definition!") 
      end
    end
  end
end
