module Admin::RequestHandlers
  extend ActiveSupport::Concern

  # 承認処理（approve）
  def handle_approval(request)
    if request.approve!
      redirect_to admin_spot_update_requests_path, notice: '修正依頼を承認し、店舗情報を更新しました'
    else
      redirect_to admin_spot_update_request_path(request), alert: '承認に失敗しました'
    end
  end

  # 却下処理（reject）
  def handle_rejection(request)
    if request.reject!
      redirect_to admin_spot_update_requests_path, notice: '修正依頼を却下しました'
    else
      redirect_to admin_spot_update_request_path(request), alert: '却下に失敗しました'
    end
  end

  # 通常更新処理（editフォームからの更新）
  def handle_normal_update(request, admin_params)
    unless request.update(admin_params)
      flash.now[:alert] = '更新に失敗しました'
      return render(:edit)
    end
    redirect_to admin_spot_update_requests_path, notice: '更新しました'
  end
end