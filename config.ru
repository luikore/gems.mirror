require "rack"
require "fileutils"
require 'thread'

M = Mutex.new
CACHE = (File.expand_path File.dirname __FILE__) + '/cache/'
TARGET = (File.expand_path File.dirname __FILE__) + '/root/'

def download path, base_name
  M.synchronize do
    target_name = TARGET + path
    if File.exist?(target_name)
      return target_name
    end
    cache_name = CACHE + base_name
    FileUtils.mkdir_p File.dirname target_name
    done = `wget -t 1 http://rubygems.org/#{path} -O #{cache_name} && echo done`
    if done.strip.end_with?('done')
      FileUtils.mv cache_name, target_name
      target_name
    end
  end
end

run(
  lambda do |env|
    path = env['REQUEST_PATH'].sub /^\/+/, ''
    base_name = (path.split '/').last
    if base_name =~ /(\.gz|\.gem)$/
      if (file = download path, base_name)
        return [200, {'X-Sendfile' => file, 'Content-Length' => '0', 'Content-Type' => 'binary/octet-stream'}, ['']]
      end
    end
    [404, {'Content-Type' => 'text/html'}, []]
  end
)
