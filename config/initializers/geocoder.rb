Geocoder.configure(
  timeout: 3,
  lookup: :nominatim,
  always_raise: :all,
  units: :km,
  use_https: true
)