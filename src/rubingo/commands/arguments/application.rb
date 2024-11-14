# frozen_string_literal: true

module Rubingo
  module Commands
    module Arguments
      module Application
        class << self
          def included(mod)
            mod.class_eval do
              argument :application, required: true, desc: 'the Scalingo application name'
              option :secnum, type: :boolean, default: false, desc: 'whether the app is hosted in the Secnum zone'
            end
          end
        end
      end
    end
  end
end
