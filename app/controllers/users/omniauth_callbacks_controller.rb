module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController

    Rails.logger.info "===OmniauthCallbacksController 読み込み完了==="


    # 認証処理
    def line

      puts "=== line コールバック実行 ==="
      puts "Auth info: #{request.env['omniauth.auth']}"
    
      @user = User.from_omniauth(request.env['omniauth.auth'], current_user)

      notify_line_already_linked and return if current_user && @user.nil?

      if @user.persisted?
        complete_line_login
      else
        fail_line_login
      end
    end

    # Google認証
    def google_oauth2
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
        sign_in_and_redirect @user, event: :authentication
      else
        redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
      end
    end

    private

    def notify_line_already_linked
      set_flash_message(:alert, :failure, kind: 'LINE', reason: '他アカウントでLINE連携済みです')
      redirect_to user_setting_path
    end

    def complete_line_login
      set_flash_message(:notice, :success, kind: 'LINE')
      sign_in_and_redirect @user, event: :authentication
    end

    def fail_line_login
      session['devise.line_data'] = request.env['omniauth.auth'].except(:extra)
      set_flash_message(:alert, :failure, kind: 'LINE', reason: 'LINE連携に失敗しました')
      redirect_to new_user_registration_url
    end
  end
end