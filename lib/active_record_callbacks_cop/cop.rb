require 'rubocop'

module ActiveRecordCallbacksCop
  class Cop < RuboCop::Cop::Base
    def self.cop_name
      "ActiveRecordCallbacks"
    end

    MSG = "Don't use ActiveRecord callbacks to add logic to your database interactions."
    RESTRICT_ON_SEND = %i[
      before_validation after_validation
      before_save around_save after_save
      before_create around_create after_create
      before_destroy around_destroy after_destroy
      after_commit
      after_create_commit after_update_commit after_destroy_commit
      after_rollback
      after_touch
    ].freeze

    def_node_matcher :active_record?, <<~PATTERN
      {
        (const {nil? cbase} :ApplicationRecord)
        (const (const {nil? cbase} :ActiveRecord) :Base)
      }
    PATTERN

    def on_send(node)
      return unless inherit_active_record_base?(node)

      add_offense(node.loc.selector)
    end

    private

    def inherit_active_record_base?(node)
      node.each_ancestor(:class).any? { |class_node| active_record?(class_node.parent_class) }
    end
  end
end
