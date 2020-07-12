# SmartCore::Initializer &middot; [![Gem Version](https://badge.fury.io/rb/smart_initializer.svg)](https://badge.fury.io/rb/smart_initializer) [![Build Status](https://travis-ci.org/smart-rb/smart_initializer.svg?branch=master)](https://travis-ci.org/smart-rb/smart_initializer)

A simple and convenient way to declare complex constructors with a support for various commonly used type systems.
 (**in active development**).

## Installation

```ruby
gem 'smart_initializer'
```

```shell
bundle install
# --- or ---
gem install smart_initializer
```

```ruby
require 'smart_core/initializer'
```

---

## Table of contents

- [Synopsis](#synopsis)
- [Access to the instance attributes](#access-to-the-instance-attributes)
- [Configuration](#configuration)
- [Type aliasing](#type-aliasing)
- [Initialization extension](#initialization-extension)
- [Plugins](#plugins)
  - [thy-types](#plugin-thy-types)
- [Roadmap](#roadmap)
- [How to run tests](#how-to-run-tests)

---

## Synopsis

**Initialization flow**:

1. Parameter + Option definitioning;
2. Original #initialize invokation;
3. Initialization extensions invokation;

**Constructor definition**:

- `param` - defines name-like attribute:
  - `cast` - type-cast received value if value has invalid type;
  - `privacy` - reader incapsulation level;
  - `finalize` - value post-processing (receives method name or proc);
  - `type_system` - differently chosen type system for the current attribute;
  - (limitation) param has no `:default` option;
- `option` - defined kwarg-like attribute:
  - `cast` - type-cast received value if value has invalid type;
  - `privacy` - reader incapsulation level;
  - `finalize` - value post-processing (receives method name or proc);
  - `default` - defalut value (if an attribute is not provided);
  - `type_system` - differently chosen type system for the current attribute;
- last `Hash` argument will be treated as `kwarg`s;

#### initializer integration

```ruby
# with pre-configured type system (:smart_types, see Configuration doc)

class MyStructure
  include SmartCore::Initializer
end
```

```ruby
# with manually chosen type system

class MyStructure
  include SmartCore::Initializer(type_system: :smart_types)
end

class AnotherStructure
  include SmartCore::Initializer(type_system: :thy_types)
end
```

#### `param` signautre:

```ruby
param <attribute_name>,
      <type=SmartCore::Types::Value::Any>, # Any by default
      cast: false, # false by default
      privacy: :public, # :public by default
      finalize: proc { |value| value }, # no finalization by default
      type_system: :smart_types # used by default
```

#### `option` signature:

```ruby
option <attribute_name>,
       <type=SmartCore::Types::Value::Any>, # Any by default
       cast: false, # false by default
       privacy: :public, # :public by default
       finalize: proc { |value| value }, # no finalization by default
       default: 123, # no default value by default
       type_system: :smart_types # used by default
```

Example:


```ruby
class User
  include SmartCore::Initializer
  # --- or ---
  include SmartCore::Initializer(type_system: :smart_types)

  param :user_id, SmartCore::Types::Value::Integer, cast: false, privacy: :public
  option :role, default: :user, finalize: -> { |value| Role.find(name: value) }

  params :name, :password
  options :metadata, :enabled
end

User.new(1, 'John', 'test123', role: :admin, metadata: {}, enabled: false)
```

---

## Access to the instance attributes

- `#__params__` - returns a list of initialized params;
- `#__options__` - returns a list of initialized options;
- `#__attributes__` - returns a list of merged params and options;

```ruby
class User
  include SmartCore::Initializer

  param :first_name, 'string'
  param :second_name, 'string'
  option :age, 'numeric'
  option :is_admin, 'boolean', default: true
end

user = User.new('Rustam', 'Ibragimov', age: 28)

user.__params__ # => { first_name: 'Rustam', second_name: 'Ibragimov' }
user.__options__ # => { age: 28, is_admin: true }
user.__attributes__ # => { first_name: 'Rustam', second_name: 'Ibragimov', age: 28, is_admin: true }
```

---

## Configuration

- based on `Qonfig` gem;
- you can read config values via `[]` or `.config.settings` or `.config[key]`;
- setitngs:
  - `default_type_system` - default type system (`smart_types` by default);

```ruby
# configure:
SmartCore::Initializer::Configuration.configure do |config|
  config.default_type_system = :smart_types # default setting value
end
```

```ruby
# read:
SmartCore::Initializer::Configuration[:default_type_system]
SmartCore::Initializer::Configuration.config[:default_type_system]
SmartCore::Initializer::Configuration.config.settings.default_type_system
```

---

## Type aliasing

- Usage:

```ruby
# for smart_types:
SmartCore::Initializer::TypeSystem::SmartTypes.type_alias('hsh', SmartCore::Types::Value::Hash)

# for thy:
SmartCore::Initializer::TypeSystem::ThyTypes.type_alias('int', Thy::Tyhes::Integer)

class User
  include SmartCore::Initializer

  param :data, 'hsh' # use your new defined type alias
  option :metadata, :hsh # use your new defined type alias

  param :age, 'int', type_system: :thy_types
end
```

- Predefined aliases:

```ruby
# for smart_types:
SmartCore::Initializer::TypeSystem::SmartTypes.type_aliases

# for thy_types:
SmartCore::Initializer::TypeSystem::ThyTypes.type_aliases
```

---

## Initialization extension

- `ext_init(&block)`:
  - you can define as many extensions as you want;
  - extensions are invoked in the order they are defined;
  - alias method: `extend_initialization_flow`;

```ruby
class User
  include SmartCore::Initializer

  option :name, :name
  option :age, :integer

  ext_init { |instance| instance.define_singleton_method(:extra) { :ext1 } }
  ext_init { |instance| instance.define_singleton_method(:extra2) { :ext2 } }
end

user = User.new(name: 'keka', age: 123)
user.name # => 'keka'
user.age # => 123
user.extra # => :ext1
user.extra2 # => :ext2
```

---

## Plugins

- [thy-types](#plugin-thy-types)

---

## Plugin: thy-types

Support for `Thy::Types` type system ([gem](https://github.com/akxcv/thy))

- install `thy` types (`gem install thy`):

```ruby
gem 'thy'
```

```shell
bundle install
```

- enable `thy_types` plugin:

```ruby
require 'thy'
SmartCore::Initializer::Configuration.plugin(:thy_types)
```

- usage:

```ruby
class User
  include SmartCore::Initializer(type_system: :thy_types)

  param :nickname, 'string'
  param :email, 'value.text', type_system: :smart_types # mixing with smart_types
  option :admin, Thy::Types::Boolean, default: false
  option :age, (Thy::Type.new { |value| value > 18 }) # custom thy type is supported too
end

# valid case:
User.new('daiver', 'iamdaiver@gmail.com', { admin: true, age: 19 })
# => new user object

# invalid case (invalid age)
User.new('daiver', 'iamdaiver@gmail.com', { age: 17 })
# SmartCore::Initializer::ThyTypeValidationError

# invaldi case (invalid nickname)
User.new(123, 'test', { admin: true, age: 22 })
# => SmartCore::Initializer::ThyTypeValidationError
```

---

## Roadmap

- Attribue Definition DSL
  - Support for specifying the attribute accessor type (`read_only` parameter);
  - Support for attribute aliasing (`as` parameter);

---

## How to run tests

- with plugin tests:

```shell
bin/rspec -w
```

- without plugin tests:

```shell
bin/rspec -n
```

- help message:

```shell
bin/rspec -h
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
