# frozen_string_literal: true

require_relative 'lib/philiprehberger/id_gen/version'

Gem::Specification.new do |spec|
  spec.name          = 'philiprehberger-id_gen'
  spec.version       = Philiprehberger::IdGen::VERSION
  spec.authors       = ['Philip Rehberger']
  spec.email         = ['me@philiprehberger.com']

  spec.summary       = 'Multi-format unique ID generator with ULID, nanoid, prefixed, and snowflake support'
  spec.description   = 'Generate unique identifiers in multiple formats: time-sortable ULIDs, ' \
                        'compact nanoids, Stripe-style prefixed IDs, and Twitter-style snowflake IDs. ' \
                        'Zero dependencies, thread-safe, cryptographically random.'
  spec.homepage      = 'https://github.com/philiprehberger/rb-id-gen'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['homepage_uri']          = spec.homepage
  spec.metadata['source_code_uri']       = spec.homepage
  spec.metadata['changelog_uri']         = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['bug_tracker_uri']       = "#{spec.homepage}/issues"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files         = Dir['lib/**/*.rb', 'LICENSE', 'README.md', 'CHANGELOG.md']
  spec.require_paths = ['lib']
end
