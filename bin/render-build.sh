set -o errexit

echo "🚀 Starting Render build process..."

# Gemのインストール
echo "📦 Installing gems..."
bundle install

# Rails 8 Solid Queue対応: スキーマファイルからテーブル作成
echo "🔧 Setting up Solid Queue tables..."
if [ -f "db/queue_schema.rb" ]; then
  bundle exec rails db:schema:load SCHEMA=db/queue_schema.rb
else
  echo "⚠️  queue_schema.rb not found, using install command..."
  bundle exec rails solid_queue:install
fi

# データベースマイグレーション
echo "🗃️  Running database migrations..."
bundle exec rails db:migrate

# アセットのビルドとクリーンアップ
echo "🎨 Precompiling assets..."
bundle exec rails assets:precompile

echo "🧹 Cleaning up assets..."
bundle exec rails assets:clean

echo "✅ Build completed successfully!"