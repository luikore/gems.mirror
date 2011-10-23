require "fileutils"
require "open-uri"
include FileUtils

cd File.dirname(__FILE__) + '/root'
Dir.glob '*.gz' do |f|
  data = open "http://rubygems.org/#{f}", &:read rescue nil
  if data and !data.empty?
    File.open '../var/renew.log', 'w+' do |s|
      s.puts "#{Time.now} renewing #{f} (#{data.size}bytes)"
    end
    File.open f, 'w' do |s|
      s << data
    end
  end
end