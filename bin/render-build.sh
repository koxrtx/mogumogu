# exit on error
set -o errexit

echo "🚀 Starting Render build process..."

# Gemのインストール
echo "📦 Installing gems..."
bundle install

# Rails 8 Solid Queue対応: 既存環境に配慮した安全な方法
echo "🔧 Setting up Solid Queue..."

# Solid Queueテーブルの存在確認
echo "🔍 Checking if Solid Queue tables already exist..."
SOLID_QUEUE_EXISTS=$(bundle exec rails runner "
begin
  tables = ActiveRecord::Base.connection.tables.grep(/solid_queue/)
  puts tables.size >= 10 ? 'true' : 'false'
rescue => e
  puts 'false'
end
" 2>/dev/null || echo 'false')

if [ "$SOLID_QUEUE_EXISTS" = "false" ]; then
  echo "📋 Solid Queue tables not found, creating them..."
  
  # 初回のみ: スキーマロード
  echo "🗃️ Loading Solid Queue schema (first time setup)..."
  DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:schema:load SCHEMA=db/queue_schema.rb
  
  echo "✅ Solid Queue schema loaded successfully!"
else
  echo "✅ Solid Queue tables already exist, skipping schema load"
  echo "🔄 Using existing Solid Queue setup"
fi

# 通常のマイグレーション（既存環境でも安全）
echo "🗃️ Running database migrations..."
bundle exec rails db:migrate

# 最終確認
echo "🔍 Final verification..."
bundle exec rails runner "
tables = ActiveRecord::Base.connection.tables.grep(/solid_queue/)
puts '✅ Solid Queue tables: ' + tables.size.to_s + '/11'
if tables.size >= 10
  puts '✅ Solid Queue is ready!'
else
  puts '⚠️ Some Solid Queue tables may be missing, but continuing...'
end
"

# アセット処理
echo "🎨 Precompiling assets..."
bundle exec rails assets:precompile

echo "🧹 Cleaning assets..."
bundle exec rails assets:clean

echo "✅ Build completed successfully!"