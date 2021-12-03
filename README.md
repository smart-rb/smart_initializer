# SmartCore::Initializer &middot; <a target="_blank" href="https://github.com/Cado-Labs"><img src="https://github.com/Cado-Labs/cado-labs-logos/raw/main/cado_labs_badge.svg" alt="Supported by Cado Labs" style="max-width: 100%; height: 20px"></a> &middot; [![Gem Version](https://badge.fury.io/rb/smart_initializer.svg)](https://badge.fury.io/rb/smart_initializer)

A simple and convenient way to declare complex constructors with a support for various commonly used type systems.
 (**in active development**).

---

<p>
  <a href="https://github.com/Cado-Labs">
    <img src="https://github.com/Cado-Labs/cado-labs-logos/blob/main/cado_labs_supporting.svg" alt="Supported by Cado Labs" />
  </a>
</p>

---

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
- [Build](#build)

---

## Synopsis

**Initialization flow**:

1. Parameter + Option definitioning;
2. Original #initialize invokation;
3. Initialization extensions invokation;

**Constructor definition**:

- `param` - defines name-like attribute:
  - `cast` (optional) - type-cast received value if value has invalid type;
  - `privacy` (optional) - reader incapsulation level;
  - `finalize` (optional) - value post-processing (receives method name or proc);
  - `type_system` (optional) - differently chosen type system for the current attribute;
  - `as`  (optional)- attribute alias (be careful with naming aliases that overlap the names of other attributes);
  - `mutable` (optional) - generate type-validated attr_writer in addition to attr_reader (`false` by default)
  - (**limitation**) param has no `:default` option;
- `option` - defined kwarg-like attribute:
  - `cast` (optional) - type-cast received value if value has invalid type;
  - `privacy` (optional) - reader incapsulation level;
  - `as` (optional) - attribute alias (be careful with naming aliases that overlap the names of other attributes);
  - `mutable` (optional) - generate type-validated attr_writer in addition to attr_reader (`false` by default)
  - `optional` (optional) - mark attribut as optional (you can may not initialize optional attributes,
    their values will be initialized with `nil` or by `default:` parameter);
  - `finalize` (optional) - value post-processing (receives method name or proc);
    - expects `Proc` object or `symbol`/`string` isntance method;
  - `default` (optional) - defalut value (if an attribute is not provided);
    - expects `Proc` object or a simple value of any type;
    - non-proc values will be `dup`licate during initialization;
  - `type_system` (optional) - differently chosen type system for the current attribute;
- `params` - define a series of parameters (supports only `mutable` option);
  - `:mutable` (optional) - (`false` by default);
- `options` - define a series of options;
  - `:mutable` (optional) - (`false` by default);
- last `Hash` argument will be treated as `kwarg`s;

#### Initializer integration

- supports per-class configurations;
- possible configurations:
  - `:type_system` - chosen type-system (`smart_types` by default);
  - `:strict_options` - fail extra kwarg-attributes, passed to the constructor (`true` by default);
  - `:auto_cast` - type-cast all values to the declared attribute type (`false` by default);

```ruby
# with pre-configured type system (:smart_types, see Configuration doc)

class MyStructure
  include SmartCore::Initializer
end
```

```ruby
# with manually chosen settings

class MyStructure
  include SmartCore::Initializer(
    type_system: :smart_types, # use smart_types
    auto_cast: true, # type-cast all values by default
    strict_options: false # ignore extra kwargs passed to the constructor
  )
end

class AnotherStructure
  include SmartCore::Initializer(type_system: :thy_types) # use thy_types and global defaults
end
```

#### `param` and `params` signautre:

```ruby
param <attribute_name>,
      <type=SmartCore::Types::Value::Any>, # Any by default
      cast: false, # false by default
      privacy: :public, # :public by default
      finalize: proc { |value| value }, # no finalization by default
      finalize: :some_method, # use this apporiach in order to finalize by `some_method(value)` instance method
      as: :some_alias, # define attribute alias
      mutable: true, # (false by default) generate type-validated attr_writer in addition to attr_reader
      type_system: :smart_types # used by default
```

```ruby
params <atribute_name1>, <attribute_name2>, <attribute_name3>, ...,
       mutable: true # generate type-validated attr_writer in addition to attr_reader (false by default);
```

#### `option` and `options` signature:

```ruby
option <attribute_name>,
       <type=SmartCore::Types::Value::Any>, # Any by default
       cast: false, # false by default
       privacy: :public, # :public by default
       finalize: proc { |value| value }, # no finalization by default
       finalize: :some_method, # use this apporiach in order to finalize by `some_method(value)` instance method
       default: 123, # no default value by default
       default: proc { 123 }, # use proc/lambda object for dynamic initialization
       as: :some_alias, # define attribute alias
       mutable: true, # (false by default) generate type-validated attr_writer in addition to attr_reader
       optional: true # (false by default) mark attribute as optional (attribute will be defined with `nil` or by `default:` value)
       type_system: :smart_types # used by default
```

```ruby
options <attribute_name1>, <attribute_name2>, <attribute_name3>, ...,
        mutable: true # generate type-validated attr_writer in addition to attr_reader (false by default);
```

Example:


```ruby
class User
  include SmartCore::Initializer
  # --- or ---
  include SmartCore::Initializer(type_system: :smart_types)

  param :user_id, SmartCore::Types::Value::Integer, cast: false, privacy: :public
  option :role, default: :user, finalize: -> { |value| Role.find(name: value) }

  # NOTE: for method-based finalizetion use `your_method(value)` isntance method of your class

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
- by default, all classes uses and inherits the Global configuration;
- configuration setitngs:
  - `default_type_system` - default type system (`smart_types` by default);
  - `:strict_options` - fail on extra kwarg-attributes passed to the constructor (`true` by default);
  - `:auto_cast` - type-cast all values to the declared attribute type (`false` by default);
- each class can be configured separately (in `include` invocation);
- global configuration affects classes used the default global configs in run-time;
- each class can be re-configured separately in run-time;

```ruby
# Global configuration:

SmartCore::Initializer::Configuration.configure do |config|
  config.default_type_system = :smart_types # default setting value
  config.strict_options = true # default setting value
  config.auto_cast = false # default setting value
end
```

```ruby
# Read configs:

SmartCore::Initializer::Configuration[:default_type_system]
SmartCore::Initializer::Configuration.config[:default_type_system]
SmartCore::Initializer::Configuration.config.settings.default_type_system
```

```ruby
# per-class configuration:

class Parameters
  include SmartCore::Initializer(auto_cast: true, strict_options: false)
  # 1. use globally configured `smart_types` (default value)
  # 2. type-cast all attributes by default (auto_cast: true)
  # 3. ignore extra kwarg-attributes passed to the constructor (strict_options: false)
end

class User
  include SmartCore::Initializer(type_system: :thy_types)
  # 1. use :thy_types isntead of pre-configured :smart_types
  # 2. use pre-configured auto_cast (false by default above)
  # 3. use pre-configured strict_options ()
end
```

```ruby
# debug class-related configurations:

class SomeClass
  include SmartCore::Initializer(type_system: :thy_types)
end

SomeClass.__initializer_settings__[:type_system] # => :thy_types
SomeClass.__initializer_settings__[:auto_cast] # => false
SomeClass.__initializer_settings__[:strict_options] # => true
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

- (in development) Attribue Definition DSL
  - Support for optional `option` attributes (`strict: true` / `strict: false` behaviour);
- Migrate from `TravisCI` to `GitHub Actions`;
- Extract `Type Interop` system to `smart_type-system`;

---

## Build

### Tests Running

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

### Code Style Checking

- without auto-correction:

```shell
bundle exec rake rubocop
```

- with auto-correction:

```shell
bundle exec rake rubocop -A
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

## Supporting

<a href="https://github.com/Cado-Labs">
  <img src="https://github.com/Cado-Labs/cado-labs-logos/blob/main/cado_labs_logo.png" alt="Supported by Cado Labs" />
</a>

## Authors

[Rustam Ibragimov](https://github.com/0exp)
