require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application

    config.load_defaults 8.0

    config.autoload_lib(ignore: %w[assets tasks])

    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}").to_s]

    # Active Storage用の設定
    config.active_storage.variant_processor = :vips

    # === Zeitwerk対策（LINE Strategy用） ===
    # libディレクトリを完全にZeitwerkから除外
    config.autoload_paths -= %W(#{config.root}/lib)
    
    # ❌ この行を削除（矛盾の原因）
    # config.eager_load_paths += %W(#{config.root}/lib) if Rails.env.production?

    # LINE Strategyの手動読み込み
    config.to_prepare do
      strategy_file = Rails.root.join('lib', 'omniauth', 'strategies', 'line.rb')
      if File.exist?(strategy_file)
        load strategy_file
        Rails.logger.info "✅ LINE strategy loaded in to_prepare"
      end
    end

    # 本番環境での追加対策
    config.after_initialize do
      # 本番環境でのLINE Strategy確実読み込み
      if Rails.env.production?
        strategy_file = Rails.root.join('lib', 'omniauth', 'strategies', 'line.rb')
        if File.exist?(strategy_file)
          load strategy_file
          Rails.logger.info "✅ LINE strategy loaded in after_initialize (production)"
        end
      end

      # Active Storageの品質オプション対処
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