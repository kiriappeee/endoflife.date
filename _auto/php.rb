require 'json'
require 'yaml'
require 'date'
require 'net/http'

def update_php_versions
  today = Date.today()
  file_content = File.read('products/php.md')
  front_matter_starting_pos = file_content.index("---", 0)
  front_matter_ending_pos = file_content.index("---", 3)

  front_matter_yaml = YAML.load(file_content[front_matter_starting_pos+3, front_matter_ending_pos-3])
  #puts front_matter_yaml['releases']
  #puts today
  active_releases = []

  for release in front_matter_yaml['releases'] do
    if release['eol'] > today
      puts "Checking latest version for release cycle #{release['releaseCycle']}"
      uri = URI("https://www.php.net/releases/index.php?json&max=1&version=#{release['releaseCycle']}")
      php_versions = JSON.load(Net::HTTP.get(uri))
      if php_versions.keys.first != release['latest']
        puts "Latest version doesn't match"
        puts "Current version #{release['latest']}"
        puts "Latest version #{php_versions.keys.first}"
        release['latest'] = php_versions.keys.first
      end
    end
  end

  #puts YAML.dump(front_matter_yaml)

  final_content = "#{YAML.dump(front_matter_yaml)}---
  #{file_content[front_matter_ending_pos+4..]}"

  File.write('products/php.md', final_content)
end