# frozen_string_literal: true

require_relative 'lib/philiprehberger/id_gen/version'

Gem::Specification.new do |spec|
  spec.name = 'philiprehberger-id_gen'
  spec.version = Philiprehberger::IdGen::VERSION
  spec.authors = ['Philip Rehberger']
  spec.email = ['me@philiprehberger.com']

  spec.summary = 'Multi-format unique ID generator with ULID, nanoid, UUID v7, CUID2, prefixed, snowflake, hashid, and encoding support'
  spec.description = 'Generate unique identifiers in multiple formats: time-sortable ULIDs, ' \
                     'compact nanoids, UUID v7, CUID2, Stripe-style prefixed IDs, Twitter-style snowflake IDs, ' \
                     'hashid obfuscation, and base-N encoding. Zero dependencies, thread-safe, cryptographically random.'
  spec.homepage = 'https://philiprehberger.com/open-source-packages/ruby/philiprehberger-id_gen'
  spec.license = 'MIT'

  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/philiprehberger/rb-id-gen'
  spec.metadata['changelog_uri'] = 'https://github.com/philiprehberger/rb-id-gen/blob/main/CHANGELOG.md'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/philiprehberger/rb-id-gen/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir['lib/**/*.rb', 'LICENSE', 'README.md', 'CHANGELOG.md']
  spec.require_paths = ['lib']
end
