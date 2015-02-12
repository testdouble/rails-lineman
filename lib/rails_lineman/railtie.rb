module RailsLineman
  class Railtie < Rails::Railtie
    config.rails_lineman = ActiveSupport::OrderedOptions.new

    config.rails_lineman.lineman_project_location = ENV['LINEMAN_PROJECT_LOCATION']
    config.rails_lineman.lineman_project_namespace = nil
    config.rails_lineman.lineman_assets = ENV['LINEMAN_ASSETS'] || [:js, :css]
    config.rails_lineman.remove_lineman_assets_after_asset_pipeline_precompilation = false
    config.rails_lineman.skip_build = false
    config.rails_lineman.copy_files_to_public_folder = false
    config.rails_lineman.tmp_dir = File.join("tmp", "rails_lineman")
    config.rails_lineman.asset_paths = [ config.rails_lineman.tmp_dir ]

    rake_tasks do
      files = []
      files <<  File.join(File.dirname(__FILE__), '..', 'tasks', 'deploy_frontend.rake')
      files << File.join(File.dirname(__FILE__), '..', 'tasks', 'assets_precompile.rake') unless config.rails_lineman.copy_files_to_public_folder
      files.each{|file| load(file)}
    end

    initializer "rails_lineman.add_asset_paths" do
      Rails.application.config.assets.paths |= config.rails_lineman.asset_paths.map { |path| Rails.root.join(path) }
      `rake deploy:frontend` if config.rails_lineman.copy_files_to_public_folder
    end

    # initializer "rails_lineman.add_frontend" do
    #   # Rails.application.config.assets.paths |= config.rails_lineman.asset_paths.map { |path| Rails.root.join(path) }
    # end
  end
end