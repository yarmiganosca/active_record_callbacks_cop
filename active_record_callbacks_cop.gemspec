
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "active_record_callbacks_cop/version"

Gem::Specification.new do |spec|
  spec.name          = "active_record_callbacks_cop"
  spec.version       = ActiveRecordCallbacksCop::VERSION
  spec.authors       = ["Chris Hoffman"]
  spec.email         = ["yarmiganosca@gmail.com"]

  spec.summary       = %q{Custom RuboCop Extension that will prevent you from adding ActiveRecord callbacks to your Rails code.}
  spec.description   = spec.summary
  spec.homepage      = "https://www.github.com/yarmiganosca/active_record_callbacks_cop"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "appraisal"

  spec.add_dependency "rubocop", ">= 0.87.0"
end
