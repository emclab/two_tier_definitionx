module TwoTierDefinitionx
  class SubDefinition < ActiveRecord::Base
    attr_accessor :active_noupdate


    belongs_to :definition, :class_name => 'TwoTierDefinitionx::Definition'
    
    validates :name, :presence => true,
                     :uniqueness => {:scope => :definition_id, :case_sensitive => false, :message => I18n.t('Duplicate Name!')}
    validates :fort_token, :presence => true
    validate :dynamic_validate 
    
    default_scope {where(fort_token: Thread.current[:fort_token])}
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate_sub_definition', self.fort_token, 'two_tier_definitionx')
      eval(wf) if wf.present?
    end   
  end
end
