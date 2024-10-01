## Pronto eslinter

Yet another `eslint` runner for the pronto ecosystem. This one provides support for warnings and suggestions.

### Installation

```bash
gem install pronto pronto-eslinter
```

Or add it to your Gemfile:

```ruby
gem 'pronto'
gem 'pronto-eslinter'
```

Add the following to your `.pronto.yml`:

```yaml
runners:
  - eslinter
```

### Configuration

#### ESlint:
ESlint will look at your `eslint.config.js` file for configuration.


#### Pronto:

```yaml
eslinter:
  # Enable suggestions in GitHub
  # This feature is very beta and is not recommended for production use. It may not work as expected.
  suggestions: true # default: false

  # Change the command to run eslint
  command: 'npx eslint' # default: 'yarn -s run eslint'

  # Change the file regex to match your files
  file_regex: '\.jsx?$' # default: '\.js$|\.jsx$|\.ts$|\.tsx$'
```

### Usage

```bash
pronto run
```
