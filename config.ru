require "rack"
require "fileutils"
require 'thread'

if RUBY_VERSION =~ /1\.8/
  class << File
    alias binread read
  end
end

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
    path = env['PATH_INFO'].sub /^\/+/, ''
    if path !~ /^(specs|latest_specs|quick|gems)/
      return [404, {'Content-Type' => 'text/html'}, []]
    end
    base_name = (path.split '/').last
    if base_name =~ /(\.gz|\.gem)$/
      if (file = download path, base_name)
        return [200, {'Content-Disposition' => "attachment; filename=#{base_name}", 'Content-Type' => 'binary/octet-stream'}, [File.binread(file)]]
      end
    end
    [404, {'Content-Type' => 'text/html'}, []]
  end
)
