set -o errexit

# Gemのインストール
bundle install

# Solid Queueのセットアップ（最初に実行）
bundle exec rails solid_queue:install

# データベースマイグレーション
bundle exec rails db:migrate

# アセットのビルドとクリーンアップ
bundle exec rails assets:precompile
bundle exec rails assets:clean