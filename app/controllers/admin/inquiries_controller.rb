class Admin::InquiriesController < Admin::BaseController
  # 各アクションの前に該当する問い合わせを取得
   # show・保留・対応中・完了・destroyで共通処理
  before_action :set_inquiry, only: [:show, :mark_as_pending, :mark_as_in_progress, :mark_as_completed, :destroy]
  
  def index
    # 検索オブジェクトを作成
    @q = Inquiry.ransack(params[:q])

    # 検索結果を取得 /一覧 .recentはモデルで定義したスコープ(作成日順)
    @inquiries = @q.result.recent.page(params[:page]).per(20)
    
    # 統計情報（ダッシュボードや上部表示用）
    @stats = {
      total: Inquiry.count,               # 総問い合わせ数
      unread: Inquiry.unread_count,       # 未読の問い合わせ件数（スコープ）
      today: Inquiry.today_count,         # 今日届いた問い合わせ件数（スコープ）
      this_week: Inquiry.this_week.count  # 今週届いた問い合わせ件数
    }
  end

  def show
  end

  # 保留にする
  def mark_as_pending
    @inquiry.update(status: :pending)
    redirect_back(fallback_location: admin_inquiries_path)
  end
  
  # 対応中にする
  def mark_as_in_progress
    @inquiry.update(status: :in_progress)
    redirect_back(fallback_location: admin_inquiries_path)
  end
  
  # 完了にする
  def mark_as_completed
    @inquiry.update(status: :completed)
    redirect_back(fallback_location: admin_inquiries_path)
  end

  def destroy
    @inquiry.destroy
    redirect_to admin_inquiries_path, notice: '問い合わせ削除'
  end

end
