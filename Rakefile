require 'yaml'
require_relative '_auto/gke'
require_relative '_auto/php'

desc "Generate gke.yml"
task :gke do
  generate_gke
end

desc "Check PHP versions"
task :php do
  update_php_versions
end