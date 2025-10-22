# LINE Strategyの強制読み込み
strategy_file = Rails.root.join('lib', 'omniauth', 'strategies', 'line.rb')

if File.exist?(strategy_file)
  load strategy_file
  Rails.logger.info "✅ LINE strategy loaded successfully"
else
  Rails.logger.error "❌ LINE strategy file not found"
end