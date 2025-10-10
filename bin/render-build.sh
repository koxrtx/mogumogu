set -o errexit

echo "🚀 Starting Render build process..."

# Gemのインストール
echo "📦 Installing gems..."
bundle install

# Rails 8 Solid Queue対応: 開発環境と同じ方法を使用
echo "🔧 Setting up Solid Queue..."
echo "📋 Using schema load method (same as development)..."

# 開発環境と同じ方法でSolid Queueを初期化
bundle exec rails db:schema:load SCHEMA=db/queue_schema.rb

# データベースマイグレーション
echo "🗃️  Running database migrations..."
bundle exec rails db:migrate

# Solid Queueテーブルの確認
echo "🔍 Verifying Solid Queue tables..."
bundle exec rails runner "
tables = ActiveRecord::Base.connection.tables.grep(/solid_queue/)
puts '✅ Found Solid Queue tables: ' + tables.size.to_s
tables.each { |table| puts '  - ' + table }
if tables.size == 11
  puts '✅ All Solid Queue tables created successfully!'
else
  puts '❌ Missing Solid Queue tables!'
  exit 1
end
"

# アセットのビルドとクリーンアップ
echo "🎨 Precompiling assets..."
bundle exec rails assets:precompile

echo "🧹 Cleaning up assets..."
bundle exec rails assets:clean

echo "✅ Build completed successfully!"