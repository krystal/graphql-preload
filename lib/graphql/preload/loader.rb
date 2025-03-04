module GraphQL
  module Preload
    # Preloads ActiveRecord::Associations when called from the Preload::Instrument
    class Loader < GraphQL::Batch::Loader
      attr_accessor :scope
      attr_reader :association, :model

      def cache_key(record)
        record.object_id
      end

      def initialize(model, association, _scope_sql)
        @association = association
        @model = model

        validate_association
      end

      def load(record)
        unless record.is_a?(model)
          raise TypeError, "Loader for #{model} can't load associations for #{record.class} objects"
        end

        return Promise.resolve(record) if association_loaded?(record)
        super
      end

      def perform(records)
        preload_association(records)
        records.each { |record| fulfill(record, record) }
      end

      private def association_loaded?(record)
        record.association(association).loaded?
      end

      private def preload_association(records)
        preloader = ActiveRecord::Associations::Preloader.new(
          records: records,
          associations: association,
          scope: preload_scope
        ).call.first
        return unless preload_scope

        # this commit changes the way preloader works with scopes
        # https://github.com/rails/rails/commit/2847653869ffc1ff5139c46e520c72e26618c199#diff-3bba5f66eb1ed62bd5700872fcd6c632
        preloader.send(:owners).each do |owner|
          preloader.send(:associate_records_to_owner, owner, preloader.records_by_owner[owner] || [])
        end
      end

      private def preload_scope
        return nil unless scope
        reflection = model.reflect_on_association(association)
        raise ArgumentError, 'Cannot specify preload_scope for polymorphic associations' if reflection.polymorphic?
        scope if scope.try(:klass) == reflection.klass
      end

      private def validate_association
        unless association.is_a?(Symbol)
          raise ArgumentError, 'Association must be a Symbol object'
        end

        unless model < ActiveRecord::Base
          raise ArgumentError, 'Model must be an ActiveRecord::Base descendant'
        end

        return if model.reflect_on_association(association)
        raise TypeError, "Association :#{association} does not exist on #{model}"
      end
    end
  end
end
