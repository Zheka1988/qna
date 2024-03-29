# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "qna"
set :repo_url, "git@github.com:Zheka1988/qna.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/qna"
set :deploy_user, "deployer"

set :pty, false
# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/master.key" #/home/deployer/qna/shared/config/....

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "storage" #/home/deployer/qna/shared/......

after 'deploy:publishing', 'unicorn:restart'