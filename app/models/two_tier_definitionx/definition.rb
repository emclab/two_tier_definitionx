module TwoTierDefinitionx
  class Definition < ActiveRecord::Base
    attr_accessor :active_noupdate
    attr_accessible :active, :brief_note, :for_which, :last_updated_by_id, :name, :ranking_index, :sub_definitions_attributes,
                    :active_noupdate,
                    :as => :role_new
    attr_accessible :active, :brief_note, :for_which, :last_updated_by_id, :name, :ranking_index, :sub_definitions_attributes,
                    :active_noupdate,
                    :as => :role_update
    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    has_many :sub_definitions, :class_name => 'TwoTierDefinitionx::SubDefinition'
    accepts_nested_attributes_for :sub_definitions, :allow_destroy => true
    
    validates :for_which, :presence => true
    validates :name, :presence => true,
                     :uniqueness => {:scope => :for_which, :case_sensitive => false, :message => I18n.t('Duplicate Name!')}
    validate :dynamic_validate 
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate_definition', 'two_tier_definitionx')
      eval(wf) if wf.present?
    end   
  end
end
