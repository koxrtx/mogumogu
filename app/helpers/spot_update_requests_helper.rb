module SpotUpdateRequestsHelper
  # チェックボックスの値を「チェックされた」と判定するためのメソッド
  def checked?(value)
    value == "1" || value == true || value == 1
  end
end
