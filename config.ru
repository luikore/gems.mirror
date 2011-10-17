require "rack"
require "fileutils"
require 'thread'

M = Mutex.new
TMP = (File.expand_path File.dirname __FILE__) + '/tmp/'
TARGET = (File.expand_path File.dirname __FILE__) + '/root/'

def download path, base_name
  M.synchronize do
    target_name = TARGET + path
    if File.exist?(target_name)
      return target_name
    end
    tmp_name = TMP + base_name
    FileUtils.mkdir_p File.dirname target_name
    done = `wget -t 1 http://rubygems.org/#{path} -O #{tmp_name} && echo done`
    if done.strip.end_with?('done')
      FileUtils.mv tmp_name, target_name
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
