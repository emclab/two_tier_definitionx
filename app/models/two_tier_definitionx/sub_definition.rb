module TwoTierDefinitionx
  class SubDefinition < ActiveRecord::Base
    attr_accessor :active_noupdate

=begin    
    attr_accessible :active, :brief_note, :definition_id, :name, :ranking_index, 
                    :active_noupdate,
                    :as => :role_new
    attr_accessible :active, :brief_note, :definition_id, :name, :ranking_index, 
                    :active_noupdate,
                    :as => :role_update
=end
    belongs_to :definition, :class_name => 'TwoTierDefinitionx::Definition'
    
    validates :name, :presence => true,
                     :uniqueness => {:scope => :definition_id, :case_sensitive => false, :message => I18n.t('Duplicate Name!')}
    validate :dynamic_validate 
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate_sub_definition', 'two_tier_definitionx')
      eval(wf) if wf.present?
    end   
  end
end
