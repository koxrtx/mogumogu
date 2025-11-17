class Admin::SpotUpdateRequestsController < Admin::BaseController
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  before_action :set_spot, only: [:show, :edit]

  def index
    # 検索
    @q = SpotUpdateRequest.ransack(params[:q])

    # 検索結果
    @requests = @q.result.recent.page(params[:page]).per(10)

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
        handle_approval
      when 'reject'
        # 却下処理：admin_paramsは使わない（パラメータエラー回避）
        handle_rejection
      else
        # 通常の更新処理：editフォームからの詳細データ更新
        # この場合のみadmin_paramsとset_admin_editingが必要
        @request.set_admin_editing
        handle_normal_update
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

  def set_request
    @request = SpotUpdateRequest.find(params[:id])
  end

  def set_spot
    @spot = @request.spot
    unless @spot
      redirect_to admin_spot_update_requests_path,
                  alert: "関連する店舗が見つかりません"
    end
  end

  # 🔥 修正点1: admin_paramsを使わずに直接モデルメソッドを呼び出し
  def handle_approval
    # approve!メソッドでステータス変更と店舗情報更新を一括処理
    if @request.approve!
      redirect_to admin_spot_update_requests_path, notice: '修正依頼を承認し、店舗情報を更新しました'
    else
      # 承認失敗時はshowページに戻る（editページではない）
      redirect_to admin_spot_update_request_path(@request), alert: '承認に失敗しました'
    end
  end

  # 🔥 修正点2: admin_paramsを使わずに直接モデルメソッドを呼び出し
  def handle_rejection
    # reject!メソッドでステータス変更のみ実行
    if @request.reject!
      redirect_to admin_spot_update_requests_path, notice: '修正依頼を却下しました'
    else
      # 却下失敗時はshowページに戻る（editページではない）
      redirect_to admin_spot_update_request_path(@request), alert: '却下に失敗しました'
    end
  end

  # 🔥 修正点3: 通常の更新処理はそのまま維持
  def handle_normal_update
    # editフォームからの詳細データ更新時のみadmin_paramsを使用
    unless @request.update(admin_params)
      flash.now[:alert] = '更新に失敗しました'
      return render(:edit)  # 編集画面に戻る
    end

    redirect_to admin_spot_update_requests_path, notice: '更新しました'
  end

  # 🔥 修正点4: admin_paramsは通常の更新時のみ使用
  # 承認・却下処理では呼び出されないため、パラメータエラーが発生しない
  def admin_params
    params.require(:spot_update_request).permit(
      :status,
      :name, :address, :tel, :opening_hours, :other_facility_comment,
      :latitude, :longitude, :business_status,
      # 🔥 修正点5: :statusが重複していたので削除
      # 子ども向け設備のパラメータ
      :child_chair, :tatami_seat, :child_tableware, :bring_baby_food,
      :stroller_ok, :child_menu, :parking, :other_facility
    )
  end
end