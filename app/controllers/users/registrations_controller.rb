# frozen_string_literal: true
class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      if resource.persisted? && session[:terms_agreement]
        create_agreement(resource)
        clear_agreement_session
      end
    end
  end

  private

  # create!失敗した時の例外処理作る予定
  # ユーザーと同意情報を agreements テーブルに保存
  def create_agreement(user)
    Agreement.create!(
      user: user,
      terms_version: "2025-10-01",
      agreed_at: session[:agreed_at],
      ip_address: session[:agreed_ip]
      )
  end

  # Agreement作成後にセッションの同意情報を削除
  def clear_agreement_session
    session.delete(:terms_agreement)
    session.delete(:agreed_at)
    session.delete(:agreed_ip)
  end
end
