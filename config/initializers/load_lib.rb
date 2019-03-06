Rails.configuration do |config|
  config.eager_load_paths << Rails.root.join('lib')
  config.autoload_paths << Rails.root.join('lib')
end