require "fileutils"
require "open-uri"
include FileUtils

cd File.dirname(__FILE__) + '/root'
Dir.glob 'spec*gz' do |f|
  data = open "http://rubygems.org/#{f}", &:read rescue nil
  if data and !data.empty?
    File.open f, 'w' do |s|
      s << data
    end
  end
end