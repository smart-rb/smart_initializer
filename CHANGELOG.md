# Changelog
All notable changes to this project will be documented in this file.

## [0.4.0] - 2020-07-12
### Added
- Attribue Definition DSL
  - Support for specifying the attribute accessor type (`read_only` parameter);
  - Support for attribute aliasing (`as` parameter);

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
