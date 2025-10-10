set -o errexit

echo "🚀 Starting Render build process..."

# Gemのインストール
echo "📦 Installing gems..."
bundle install

# Rails 8 Solid Queue対応: マイグレーションベースのアプローチ
echo "🔧 Setting up Solid Queue..."
if [ -f "db/queue_schema.rb" ]; then
  echo "📋 Solid Queue schema found, using migration approach..."
  # Solid Queueのマイグレーションを実行
  bundle exec rails solid_queue:install:migrations
else
  echo "⚠️  Installing Solid Queue..."
  bundle exec rails solid_queue:install
fi

# データベースマイグレーション（Solid Queueも含む）
echo "🗃️  Running database migrations..."
bundle exec rails db:migrate

# アセットのビルドとクリーンアップ
echo "🎨 Precompiling assets..."
bundle exec rails assets:precompile

echo "🧹 Cleaning up assets..."
bundle exec rails assets:clean

echo "✅ Build completed successfully!"