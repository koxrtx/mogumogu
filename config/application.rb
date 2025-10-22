require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application

    config.load_defaults 8.0

    config.autoload_lib(ignore: %w[assets tasks])

    config.i18n.default_locale = :ja  # 追加
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}").to_s]  # 追加

    # Active Storage用の設定
    config.active_storage.variant_processor = :vips

    # Zeitwerkからlibディレクトリを除外（カスタムOmniAuthストラテジー用）
    config.autoload_paths -= %W(#{config.root}/lib)
    
    # または、特定のomniauth部分のみ除外
    # Rails.autoloaders.main.ignore(Rails.root.join('lib', 'omniauth'))
    config.to_prepare do
      # Zeitwerkの干渉を完全に回避
      strategy_file = Rails.root.join('lib', 'omniauth', 'strategies', 'line.rb')
      load strategy_file if File.exist?(strategy_file)
    end
    
    # 本番環境での早期読み込み
    config.eager_load_paths += %W(#{config.root}/lib) if Rails.env.production?

    config.after_initialize do
      # 品質オプションをサポートしていない場合の対処
      ActiveStorage::Variant.class_eval do
        private

        def process_options(options)
        # qualityオプションを除外
        options.except(:quality)
        end
      end
    end
  end
end
