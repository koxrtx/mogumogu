module Admin::RequestHandlers
  extend ActiveSupport::Concern

  # 承認処理（approve）
  # redirect_path: 成功時のリダイレクト先を渡す
  def handle_approval(request, redirect_path:, failure_path: nil)
    if request.approve!
      redirect_to redirect_path, notice: '修正依頼を承認しました'
    else
      redirect_to (failure_path || redirect_path), alert: '承認に失敗しました'
    end
  end

  # 却下処理（reject）
  def handle_rejection(request, redirect_path:, failure_path: nil)
    if request.reject!
      redirect_to redirect_path, notice: '修正依頼を却下しました'
    else
      redirect_to (failure_path || redirect_path), alert: '却下に失敗しました'
    end
  end

  # 通常更新処理（editフォームからの更新）
  def handle_normal_update(request, admin_params, redirect_path:, failure_path: nil)
    unless request.update(admin_params)
      flash.now[:alert] = '更新に失敗しました'
      return render(:edit)
    end
    redirect_to redirect_path, notice: '更新しました'
  end
end