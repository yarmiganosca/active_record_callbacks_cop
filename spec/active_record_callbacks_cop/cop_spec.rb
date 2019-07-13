module ActiveRecordCallbacksCop
  RSpec.describe Cop do
    subject(:cop) { described_class.new }

    let(:config) { RuboCop::Config.new }

    callback_names = %i[
      before_save around_save after_save
      before_create around_create after_create
      before_destroy around_destroy after_destroy
      after_commit
      after_create_commit after_update_commit after_destroy_commit
      after_rollback
    ]

    callback_names.each do |callback_name|
      it "registers an offense when `#{callback_name}` is used in an ApplicationRecord subclass" do
        callback_line = "  #{callback_name} :do_the_thing"
        offense_line  = "  #{"^" * (callback_line.chars.size - 2)} Don't use ActiveRecord callbacks"

        application_record_text = [
          "class MyModel < ApplicationRecord",
          callback_line,
          offense_line,
          "end"
        ].join("\n")

        expect_offense(application_record_text)
      end

      it "registers an offense when `#{callback_name}` is used in an ActiveRecord::Base subclass" do
        callback_line = "  #{callback_name} :do_the_thing"
        offense_line  = "  #{"^" * (callback_line.chars.size - 2)} Don't use ActiveRecord callbacks"

        active_record_base_text = [
          "class MyModel < ActiveRecord::Base",
          callback_line,
          offense_line,
          "end"
        ].join("\n")

        expect_offense(active_record_base_text)
      end
    end

    # here we're testing that the custom cop_name is being set correctly,
    # not rubocop's disable feature
    it "can be disabled with `# rubocop:disable ActiveRecordCallbacks`" do
      inspect_source(<<~RUBY)
        class MyModel < ApplicationRecord
          before_save :do_the_thing # rubocop:disable ActiveRecordCallbacks
        end
      RUBY

      expect(cop.offenses.size).to eq 1

      offense = cop.offenses.first

      expect(offense).to be_disabled
    end
  end
end
