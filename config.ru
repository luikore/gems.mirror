require "rack"
require "fileutils"
require "open-uri"
require "thread"

FileUtils.cd File.dirname(__FILE__)

TARGET = (File.expand_path File.dirname __FILE__) + '/root/'
M = Mutex.new

def download host, path, base_name
  target = TARGET + path
  FileUtils.mkdir_p File.dirname target
  data = open "http://#{host}/#{path}", &:read
  M.synchronize do
    File.open target, 'wb' do |f|
      f << data
    end
  end
  [target, data]
end

run(
  lambda do |env|
    path = env['PATH_INFO'].sub /^\/+/, ''
    case path
    when /\.(gz|rz|gem)$/
      base_name = (path.split '/').last
      host = env["HTTP_X_FORWARDED_HOST"] || env['HTTP_HOST'] || 'rubygems.org'
      file, data = download host, path, base_name
      [200, {'Content-Disposition' => "attachment; filename=#{base_name}", 'Content-Type' => 'binary/octet-stream'}, [data]]
    else
      [404, {'Content-Type' => 'text/html'}, ['Not found']]
    end
  end
)
