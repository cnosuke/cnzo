require 'dotenv'
Dotenv.load

# To run this sinatra application with unicorn on production, exec this command below.
# be unicorn -E production -c config/unicorn.rb

# paths
app_path = ENV['APP_PATH']
working_directory app_path
pid "#{app_path}/tmp/unicorn.pid"

# listen
listen ENV['SINATRA_LISTEN']

# logging
stderr_path "#{app_path}/log/unicorn.stderr.log"
stdout_path "#{app_path}/log/unicorn.stdout.log"

# workers
worker_processes 2

# use correct Gemfile on restarts
before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{app_path}/Gemfile"
end

# preload
preload_app true

before_fork do |server, worker|
  # Before forking, kill the master process that belongs to the .oldbin PID.
  # This enables 0 downtime deploys.
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

before_exec do |server|
  # cf. http://eagletmt.hateblo.jp/entry/2015/02/21/015956
  Dotenv.overload
end
