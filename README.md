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

## Synopsis

**Constructor definition**:

- `param` - defines name-like attribute:
  - `cast` - type-cast received value if value has invalid type;
  - `privacy` - reader incapsulation level;
  - `finalize` - value post-processing (receives method name or proc);
  - (limitation) param has no `:default` option;
- `option` - defined kwarg-like attribute:
  - `cast` - type-cast received value if value has invalid type;
  - `privacy` - reader incapsulation level;
  - `finalize` - value post-processing (receives method name or proc);
  - `default` - defalut value (if an attribute is not provided);
- last `Hash` argument will be treated as `kwarg`s;

`param` signautre:

```ruby
param <attribute_name>,
      <type=SmartCore::Types::Value::Any>, # Any by default
      cast: false, # false by default
      privacy: :public, # :public by default
      finalize: proc { |value| value } # no finalization by default
```

`option` signature:

```ruby
option <attribute_name>,
       <type=SmartCore::Types::Value::Any>, # Any by default
       cast: false, # false by default
       privacy: :public, # :public by default
       finalize: proc { |value| value }, # no finalization by default
       default: 123 # no default value by default
```

Example:


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

---

## Type aliasing

- Usage:

```ruby
# define your own type alias
SmartCore::Initializer.type_alias(:hash, SmartCore::Types::Value::Hash)

class User
  include SmartCore::Initializer

  param :data, :hash # use your new defined type alias
  option :metadata, :hash # use your new defined type alias
end
```

- Predefined aliases:
  - `:nil` => `SmartCore::Types::Value::Nil`
  - `:string` => `SmartCore::Types::Value::String`
  - `:symbol` => `SmartCore::Types::Value::Symbol`
  - `:text` => `SmartCore::Types::Value::Text`
  - `:integer` => `SmartCore::Types::Value::Integer`
  - `:float` => `SmartCore::Types::Value::Float`
  - `:numeric` => `SmartCore::Types::Value::Numeric`
  - `:boolean` => `SmartCore::Types::Value::Boolean`
  - `:array` => `SmartCore::Types::Value::Array`
  - `:hash` => `SmartCore::Types::Value::Hash`
  - `:proc` => `SmartCore::Types::Value::Proc`
  - `:class` => `SmartCore::Types::Value::Class`
  - `:module` => `SmartCore::Types::Value::Module`
  - `:any` => `SmartCore::Types::Value::Any`

---

## Initialization flow extension

```ruby
class User
  include SmartCore::Initializer

  option :name, :name
  option :age, :integer

  ext_init { |value| value.define_singleton_method(:extra) { :ext1 } }
  ext_init { |value| value.define_singleton_method(:extra2) { :ext2 } }
end

user = User.new(name: 'keka', age: 123)
user.name # => 'keka'
user.age # => 123
user.extra # => :ext1
user.extra2 # => :ext2
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
