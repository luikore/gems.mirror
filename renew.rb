require "fileutils"
include FileUtils

cd File.dirname(__FILE__) + '/root'
Dir.glob 'spec*gz' do |f|
  done = `wget -t 1 http://rubygems.org/#{f} -O ../tmp/#{f} && echo done`
  if done.strip.end_with?('done')
    mv "../tmp/#{f}", f
  end
end