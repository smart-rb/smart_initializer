# frozen_string_literal: true

class SmartCore::Initializer::TypeSystem::Interop
  # @api private
  # @since 0.1.0
  class SmartTypes < AbstractFactory
    require_relative 'smart_types/valid'
    require_relative 'smart_types/validate'
    require_relative 'smart_types/cast'

    class << self
      # @param type [SmartCore::Types::Primitive]
      # @return [SmartCore::Initializer::TypeSystem::Interop::SmartTypes::Valid]
      #
      # @api private
      # @since 0.1.0
      def build_valid_operation(type)
        SmartTypes::Valid.new(type)
      end

      # @param type [SmartCore::Types::Primitive]
      # @return [SmartCore::Initializer::TypeSystem::Interop::SmartTypes::Validate]
      #
      # @api private
      # @since 0.1.0
      def build_validate_operation(type)
        SmartTypes::Validate.new(type)
      end

      # @param type [SmartCore::Types::Primitive]
      # @return [SmartCore::Initializer::TypeSystem::Interop::SmartTypes::Cast]
      #
      # @api private
      # @since 0.1.0
      def build_cast_operation(type)
        SmartTypes::Cast.new(type)
      end
    end
  end
end
