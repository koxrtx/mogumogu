# SpotUpdateRequest の private メソッド用
module SpotUpdateRequestPrivateMethods
  extend ActiveSupport::Concern

  private

  def image_delete?; checkbox == "image_delete"; end
  def spot_update?; checkbox == "spot_update"; end
  def closure?; checkbox == "closure"; end
  def user_submission?; !admin_editing?; end
  def admin_editing?; false; end

  # 店舗情報修正時は写真削除できない
  def spot_update_excludes_other_fields
    if spot_update_request_images.any?
      errors.add(:base, "店舗情報修正依頼のときは写真削除はできません")
    end
  end

  # 閉店依頼時は写真削除も店舗情報修正もできない
  def closure_excludes_all_fields
    if spot_update_request_images.any? || facility_tag_id.present? || request_data.present?
      errors.add(:base, "閉店依頼のときは写真削除や店舗情報変更はできません")
    end
  end
end