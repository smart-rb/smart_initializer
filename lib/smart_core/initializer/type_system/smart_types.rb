# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::TypeSystem::SmartTypes < SmartCore::Initializer::TypeSystem::Interop
  require_relative 'smart_types/abstract_factory'
  require_relative 'smart_types/operation'
end
