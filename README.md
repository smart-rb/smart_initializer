# SmartCore::Initializer &middot; [![Gem Version](https://badge.fury.io/rb/smart_initializer.svg)](https://badge.fury.io/rb/smart_initializer) [![Build Status](https://travis-ci.org/smart-rb/smart_initializer.svg?branch=master)](https://travis-ci.org/smart-rb/smart_initializer)

A simple and convenient way to declare complex constructors (**in active development**).

## Installation

```ruby
gem 'smart_initializer'
```

```shell
bundle install
# --- or ---
gem install smart_types
```

```ruby
require 'smart_core/types'
```

---

## Synopsis (DEMO)

```ruby
class User
  include SmartCore::Initializer

  param :user_id, SmartCore::Types::Value::Integer, cast: false, privacy: :public
  option :role, default: :user, finalize: -> { |value| Role.find(name: value) }

  params :name, :password
  options :metadata, :enabled
end

User.new(1, 'John', 'test123', role: :admin, metadata: {}, enabled: false)
```

**Limitations**:

- `param` has no :default option (at all);
- last hash argument will be treated as `kwarg`s;

**Type aliasing**:

```ruby
SmartCore::Initializer.type_alias(:hash, SmartCore::Types::Value::Hash)

class User
  include SmartCore::Initializer

  param :data, :hash
  option :metadata, :hash
end
```

---

## Contributing

- Fork it ( https://github.com/smart-rb/smart_initializer )
- Create your feature branch (`git checkout -b feature/my-new-feature`)
- Commit your changes (`git commit -am '[feature_context] Add some feature'`)
- Push to the branch (`git push origin feature/my-new-feature`)
- Create new Pull Request

## License

Released under MIT License.

## Authors

[Rustam Ibragimov](https://github.com/0exp)
