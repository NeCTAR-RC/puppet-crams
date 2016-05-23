require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'

PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.send('disable_class_parameter_defaults')
PuppetLint.configuration.send('disable_double_quoted_strings')
PuppetLint.configuration.send('disable_names_containing_dash')
PuppetLint.configuration.send('disable_documentation')
PuppetLint.configuration.send('disable_autoloader_layout')
PuppetLint.configuration.send('disable_unquoted_resource_title')

desc "Run lint, and spec tests."
task :test => [
  :lint,
  :spec,
]
