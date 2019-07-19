# ActiveRecordCallbacksCop

Use this [RuboCop](https://github.com/rubocop-hq/rubocop) extension to stop yourself from using ActiveRecord callbacks. They'll only hurt you in the long run and its best to avoid them from the start.

These are the callbacks ActiveRecord provides:

- `before_validation`/`after_validation`
- `before_create`/`around_create`/`after_create`
- `before_save`/`around_save`/`after_save`
- `before_destroy`/`around_destroy`/`after_destroy`
- `after_touch`
- `after_commit`
- `after_create_commit`/`after_update_commit`/`after_destroy_commit`
- `after_rollback`
- `after_initialize`/`after_find`

This cop registers offenses whenever it sees any of these class methods called in `ApplicationRecord` or `ActiveRecord::Base` subclasses, except for `after_iniitalize` and `after_find`.

## Installation

Install the `active_record_callbacks_cop` gem

```bash
gem install active_record_callbacks_cop
```

or if you use bundler put this in your `Gemfile`

```
gem 'active_record_callbacks_cop'
```

## Usage

You need to tell RuboCop to load the RSpec extension. There are three ways to do this:

### RuboCop configuration file

Put this into your `.rubocop.yml`.

```yaml
require: active_record_callbacks_cop
```

Alternatively, use the following array notation when specifying multiple extensions.

```yaml
require:
  - rubocop-other-extension
  - active_record_callbacks_cop
```

Now you can run `rubocop` and it will automatically load this cop together with your other cops.

### Command line

```bash
rubocop --require active_record_callbacks_cop
```

### Rake task

```ruby
RuboCop::RakeTask.new do |task|
  task.requires << 'active_record_callbacks_cop'
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yarmiganosca/active_record_callbacks_cop. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the ActiveRecordCallbacksCop project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/yarmiganosca/active_record_callbacks_cop/blob/master/CODE_OF_CONDUCT.md).
