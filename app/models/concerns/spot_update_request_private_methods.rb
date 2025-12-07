# SpotUpdateRequest の private メソッド用
module SpotUpdateRequestPrivateMethods
  extend ActiveSupport::Concern

  # 管理者編集モードを設定
  def set_admin_editing(value = true)
    @admin_editing = value
  end

  private

  # 依頼タイプが「写真削除」の場合
  def image_delete?; request_type == "image_delete"; end
  # 依頼タイプが「店舗情報修正」の場合
  def spot_update?; request_type == "spot_update"; end
  # 依頼タイプが「閉店依頼」の場合
  def closure?; request_type == "closure"; end
  # ユーザーが提出した依頼かどうか
  def user_submission?; !admin_editing?; end
  # 管理者による編集かどうか（デフォルトは false）
  def admin_editing?
    @admin_editing == true
  end


  # 店舗情報修正時は写真削除できない
  #def spot_update_excludes_other_fields
    #if spot_image_update_requests.any?
      #errors.add(:base, "店舗情報修正依頼のときは写真削除はできません")
    #end
  #end

  # 閉店依頼時は写真削除も店舗情報修正もできない
  #def closure_excludes_all_fields
   #if spot_image_update_requests.any? || facility_tag_id.present? || request_data.present?
     # errors.add(:base, "閉店依頼のときは写真削除や店舗情報変更はできません")
    #end
  #end
end