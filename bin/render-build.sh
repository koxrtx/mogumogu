# exit on error
set -o errexit

echo "🚀 Starting Render build process..."

# Gemのインストール
echo "📦 Installing gems..."
bundle install

# Rails 8 Solid Queue対応: 正しいコマンドを使用
echo "🔧 Setting up Solid Queue..."
bundle exec rails solid_queue:install

# データベースマイグレーション（Solid Queueも含む）
echo "🗃️  Running database migrations..."
bundle exec rails db:migrate

# アセットのビルドとクリーンアップ
echo "🎨 Precompiling assets..."
bundle exec rails assets:precompile

echo "🧹 Cleaning up assets..."
bundle exec rails assets:clean

echo "✅ Build completed successfully!"