# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'structure_guard'
set :repo_url, 'git@bitbucket.org:jakealbaugh/structure-guard.git'

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/sgadmin/structure_guard/public'

# Default value for keep_releases is 5
set :keep_releases, 5

# set :log_level, :info
# set :log_level, :debug

set :linked_files, %w{config/database.yml db/production.sqlite3}
set :linked_dirs, %w{log tmp public/system/jobs public/system/manufacturing_jobs}

SSHKit.config.command_map[:rake]  = "bundle exec rake" #8
SSHKit.config.command_map[:rails] = "bundle exec rails"

namespace :deploy do

  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end

  after :finishing, "deploy:cleanup"

end

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }