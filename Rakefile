require 'rake'
require 'rake/clean'
require 'date'
require 'time'

# All the bacon specifications
PROJECT_SPECS = Dir.glob(File.expand_path('../spec/**/*.rb', __FILE__))
PROJECT_SPECS.reject! { |e| e =~ /helper\.rb/ }
PROJECT_SPECS.reject! { |e| e =~ /init\.rb/ }

RAMAZE_ROOT = File.expand_path(File.dirname(__FILE__))

CLEAN.include %w[
  **/.*.sw?
  *.gem
  .config
  **/*~
  **/{*.db,cache.yaml}
  *.yaml
  pkg
  rdoc
  public/doc
  *coverage*
]

Dir.glob(File.expand_path('../tasks/*.rake', __FILE__)).each do |f|
  import(f)
end

# Set the default task to running all the bacon specifications
task :default => [ :bacon ]

multitask :start => [ 'metrics:start', 'server:start' ]
multitask :stop => [ 'metrics:stop', 'server:stop' ]

