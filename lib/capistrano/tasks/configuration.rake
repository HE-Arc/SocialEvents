 
# Upload local configuration to server
namespace :deploy do
  desc "Upload configuration"
  task :upload_configuration do
    # this mean that we upload the file on hosts of role web, app and db
    on roles(:web, :app, :db) do
      # capistrano use SCP to upload the local file to the remote host
      upload!(File.expand_path('../../../../config/app.yml', __FILE__), "#{fetch(:release_path)}/config/app.yml")
    end
  end
 
  # this mean that this task is run after code is updated on remote servers (but before app is restarted)
  before "deploy:updated", :upload_configuration
end
