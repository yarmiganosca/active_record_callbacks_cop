require 'tmpdir'
require 'open3'
require 'bundler'

RSpec.describe "using this gem in a Rails app" do
  context "once required in .rubocop.yml" do
    around do |example|
      Dir.mktmpdir do |tmpdir|
        Bundler.with_clean_env do
          Dir.chdir(tmpdir) do
            expect(
              system('rails new test_app --skip-bundle 1>&2')
            ).to be true

            Dir.chdir("test_app") do
              app_gemfile       = Pathname.pwd/'Gemfile'
              absolute_gem_path = (Pathname.new(__FILE__)/'..'/'..').realpath

              app_gemfile.write(<<~GEMFILE, app_gemfile.size)
                gem 'rubocop'
                gem 'active_record_callbacks_cop', path: '#{absolute_gem_path}'
              GEMFILE

              expect(
                system(
                  { 'BUNDLE_GEMFILE' => app_gemfile.to_s },
                  'bundle install',
                )
              ).to be true

              (Pathname.pwd/'.rubocop.yml').write(<<~YAML)
                require: active_record_callbacks_cop
              YAML

              example.run
            end
          end
        end
      end
    end

    # we don't need to test every callback method here, since what we're testing
    # is that our install instructions in the README actually work
    it "registers an offense if you use `before_save` in an ApplicationRecord subclass" do
      (Pathname.pwd/'app'/'models'/'my_model.rb').write(<<~MODEL)
        class MyModel < ApplicationRecord
          before_save :do_the_thing
        end
      MODEL

      rubocop_output, process_status = Open3.capture2('bundle exec rubocop app/models/my_model.rb')

      expect(rubocop_output).to match(
        /^app\/models\/my_model\.rb(?<rubocop_fluff>.*)ActiveRecordCallbacks:\ Don't\ use\ ActiveRecord\ callbacks\n\ \ before_save\ :do_the_thing$/m
      )

      expect(process_status).to_not be_success
    end
  end
end
