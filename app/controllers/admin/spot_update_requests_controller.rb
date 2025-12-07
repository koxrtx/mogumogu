class Admin::SpotUpdateRequestsController < Admin::BaseController
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  before_action :set_spot_from_request, only: [:show, :edit]

  # 認証系の処理
  include Admin::RequestHandlers

  def index
    # 検索
    @q = SpotUpdateRequest.ransack(params[:q])

    # 検索結果
    @requests = @q.result
                      .where(request_type: [:spot_update, :closure])
                      .recent
                .page(params[:page])
                .per(10)

    # 統計情報（ダッシュボードや上部表示用）
    @stats = {
      pending: SpotUpdateRequest.pending.count,          # 未処理の依頼件数
      today: SpotUpdateRequest.today.count,              # 今日届いた依頼件数
      this_week: SpotUpdateRequest.this_week.count       # 今週届いた依頼件数
    }
  end

  def show
  end

  def edit
  end

  # 管理者側に店舗情報修正依頼きたときのコントローラー
  def update
    begin
      # commitパラメータで処理を分岐
      case params[:commit]
      when 'approve'
        # 承認処理：admin_paramsは使わない（パラメータエラー回避）
        handle_approval(@request, redirect_path: admin_spot_update_requests_path)
      when 'reject'
        # 却下処理：admin_paramsは使わない（パラメータエラー回避）
        handle_rejection(@request, redirect_path: admin_spot_update_requests_path)
      else
        # 通常の更新処理：editフォームからの詳細データ更新
        # この場合のみadmin_paramsとset_admin_editingが必要
        @request.set_admin_editing
        handle_normal_update(@request, admin_params, redirect_path: admin_spot_update_requests_path)

      end
    rescue => e
      # エラーハンドリング：予期しないエラーをキャッチ
      redirect_to admin_spot_update_request_path(@request), alert: "エラーが発生しました: #{e.message}"
    end
  end

  def destroy
    @request.destroy
    redirect_to admin_spot_update_requests_path, notice: '依頼を削除しました'
  end

  private


  # admin_paramsは通常の更新時のみ使用
  # 承認・却下処理では呼び出されないため、パラメータエラーが発生しない
  def admin_params
    params.require(:spot_update_request).permit(
      :status,
      :name, :address, :tel, :opening_hours, :other_facility_comment,
      :latitude, :longitude, :business_status,
      # 子ども向け設備のパラメータ
      :child_chair, :tatami_seat, :child_tableware, :bring_baby_food,
      :stroller_ok, :child_menu, :parking, :other_facility
    )
  end
end