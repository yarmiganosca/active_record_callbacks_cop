require 'rubocop'

module ActiveRecordCallbacksCop
  class Cop < RuboCop::Cop::Cop
    def self.cop_name
      "ActiveRecordCallbacks"
    end

    MSG = "Don't use ActiveRecord callbacks to add logic to your database interactions."

    def on_send(node)
      return unless callback_names.include?(node.method_name)
      return unless node.parent.class_type? &&
        node.parent.parent_class &&
        parent_class_names.include?(node.parent.parent_class.const_name)

      add_offense(node)
    end

    private

    def parent_class_names
      %w(ActiveRecord::Base ApplicationRecord)
    end

    # TODO: decide whether to ban before_validation/after_validation
    # TODO: decide whether to ban after_initialize/after_find
    # TODO: decide whether to ban after_touch
    # TODO: maybe there should be separate cops for groups of callbacks?
    def callback_names
      %i(
        before_save around_save after_save
        before_create around_create after_create
        before_destroy around_destroy after_destroy
        after_commit
        after_create_commit after_update_commit after_destroy_commit
        after_rollback
      )
    end
  end
end
