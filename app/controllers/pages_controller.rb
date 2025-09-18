class PagesController < ApplicationController
  # 利用規約画面
  def terms
  end

  # 同意画面
  def terms_agreement

  end

  def create_agreement
    if params[:agreed] == '1'
      session[:terms_agreement] = true
      session[:agreed_at] = Time.current
      session[:agreed_ip] = request.remote_ip

      redirect_to new_user_registration_path
    else
      # 同意しない場合は同意画面に戻る
      flash[:danger] = '利用規約への同意が必要です'
      redirect_to terms_agreement_path
    end
  end

end
