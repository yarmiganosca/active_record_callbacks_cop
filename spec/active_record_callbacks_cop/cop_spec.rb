module ActiveRecordCallbacksCop
  RSpec.describe Cop do
    subject(:cop) { described_class.new }

    let(:config) { RuboCop::Config.new }

    callback_names = %i[
      before_validation after_validation
      before_save around_save after_save
      before_create around_create after_create
      before_destroy around_destroy after_destroy
      after_commit
      after_create_commit after_update_commit after_destroy_commit
      after_rollback
      after_touch
    ]

    callback_names.each do |callback_name|
      context "when `#{callback_name}` is used in an ApplicationRecord subclass" do
        it "registers an offense" do
          callback_line = "  #{callback_name} :do_the_thing"
          offense_line  = "  #{"^" * (callback_line.chars.size - 2)} #{described_class::MSG}"

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
          offense_line  = "  #{"^" * (callback_line.chars.size - 2)} #{described_class::MSG}"

          active_record_base_text = [
            "class MyModel < ActiveRecord::Base",
            callback_line,
            offense_line,
            "end"
          ].join("\n")

          expect_offense(active_record_base_text)
        end
      end
    end

    context "in a class with no parent class" do
      context "when before_save is used" do
        it "doesn't register an offense" do
          expect_no_offenses(<<~RUBY)
            class A
              before_save :do_the_thing
            end
          RUBY
        end
      end

      context "when another class method is used" do
        it "doesn't register an offense" do
          expect_no_offenses(<<~RUBY)
            class A
              some_class_method :do_the_thing
            end
          RUBY
        end
      end
    end

    context "in a class with a parent class we don't care about" do
      context "when before_save is used" do
        it "doesn't register an offense" do
          expect_no_offenses(<<~RUBY)
            class A < B
              before_save :do_the_thing
            end
          RUBY
        end
      end

      context "when another class method is used" do
        it "doesn't register an offense" do
          expect_no_offenses(<<~RUBY)
            class A < B
              some_class_method :do_the_thing
            end
          RUBY
        end
      end
    end

    context "in a RSpec example group" do
      context "when a class method is used" do
        it "doesn't register an offense" do
          expect_no_offenses(<<~RUBY)
            RSpec.describe Something do
              it "does something" do
                expect(something)
              end
            end
          RUBY
        end
      end
    end

    context "inside a method" do
      context "when before_save is used" do
        it "doesn't register an offense" do
          expect_no_offenses(<<~RUBY)
            class A
              def something
                before_save :do_the_thing
              end
            end
          RUBY
        end
      end
    end

    context "in a module" do
      context "when before_save is used" do
        it "doesn't register an offense" do
          expect_no_offenses(<<~RUBY)
            module A
              before_save :do_the_thing
            end
          RUBY
        end
      end

      context "when another class method is used" do
        it "doesn't register an offense" do
          expect_no_offenses(<<~RUBY)
            module A
              some_class_method :do_the_thing
            end
          RUBY
        end
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
