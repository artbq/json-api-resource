ENV['gem_push'] = 'false'

require 'bundler/gem_tasks'

Rake::Task['release'].enhance do
  spec = Gem::Specification::load(Dir.glob('*.gemspec').first)
  sh "gem inabox pkg/#{spec.name}-#{spec.version}.gem"
end
