# 開発中と本番環境で設定変更
if Rails.env.development?
  Geocoder.configure(
  lookup: :google,
  api_key: ENV["GOOGLE_MAPS_SERVER_KEY"],
  use_https: true,
  timeout: 5,
  units: :km,
  always_raise: :all
)
else
  Geocoder.configure(
    lookup: :google,
    api_key: ENV["GOOGLE_MAPS_SERVER_KEY"],
    use_https: true,
    timeout: 5,
    units: :km
    # 本番では always_raise は外して rescue で対応する
  )
end