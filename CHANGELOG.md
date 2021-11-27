# Changelog
All notable changes to this project will be documented in this file.

## [Unreleased]
- Приведена в порядок конфигурация "strict_options":
  - поправлено наследование (ранее не наслоедовалась)
  - поправлена возможность указания этой опции при инклуде модуля (ранее не давалась возможность)
  - глобальное поведение изменено на локальное для каждого класса (ранее на все сразу распространялось)

## [0.7.0] - 2021-06-23
## Added
- `strict_options` config option for non-strict checking of passed options;

## [0.6.0] - 2021-06-23
## Added
- Validation messages for incorrect attribute types;

## [0.5.0] - 2021-01-18
## Changed
- Updated `smart_types` dependency (`~> 0.4.0`) to guarantee **Ruby@3** compatibility;
- Updated development dependencies;

## [0.4.0] - 2021-01-18
### Added
- Support for **Ruby 3**;

### Changed
- Moved from `TravisCI` to nothing (todo: migrate to `GitHub Actions`).
  Temporary: we must run test cases locally.
- Updated development dependencies;

## [0.3.2] - 2020-07-12
### Fixed
- Deeply inherited entities lose their `__initializer_settings__` entitiy;

## [0.3.1] - 2020-07-12
### Fixed
- Deeply inherited entities lose their class attribute definers;

## [0.3.0] - 2020-07-11
### Added
- `extend_initialization_flow` alias method for `SmartCore::Initializer.ext_init`;
- Access methods to the instance attribute lists (`#__params`, `#__options__`, `#__attributes__`);

### Changed
- Updated development dependencies;

## [0.2.0] - 2020-05-16
### Changed
- **Constructor**: disallow unknown option attributes;

## [0.1.0] - 2020-05-10
- Release :)
