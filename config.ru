require "rack"
require "fileutils"
require "open-uri"
require "thread"

TARGET = (File.expand_path File.dirname __FILE__) + '/root/'
M = Mutex.new

def download path, base_name
  target = TARGET + path
  FileUtils.mkdir_p File.dirname target
  data = open "http://rubygems.org/#{path}", &:read
  M.synchronize do
    File.open target, 'wb' do |f|
      f << data
    end
  end
  [target, data]
end

def index
  gems = Dir.entries('root/gems').join "\n"
  <<-HTML
  <html><head></head><body>
    <pre>#{gems}</pre>
  </body></html>
  HTML
end

run(
  lambda do |env|
    path = env['PATH_INFO'].sub /^\/+/, ''
    case path
    when ''
      [200, {'Content-Type' => 'text/html'}, [index]]
    when /\.(gz|rz|gem)$/
      base_name = (path.split '/').last
      file, data = download path, base_name
      [200, {'Content-Disposition' => "attachment; filename=#{base_name}", 'Content-Type' => 'binary/octet-stream'}, [data]]
    else
      [404, {'Content-Type' => 'text/html'}, ['Not found']]
    end
  end
)
