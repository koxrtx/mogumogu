document.addEventListener('turbo:load', function(){
  console.log("Turbo:load 発火");

  const locationButton = document.getElementById("current-address-btn");

  if (!locationButton) return;

  // ボタンを押した時の処理
  locationButton.addEventListener("click", () => {
    console.log("ボタンクリック検知");

    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          const pos = {
            lat: position.coords.latitude,
            lng: position.coords.longitude,
          };
          console.log("位置情報取得:", pos);

          // 逆ジオコーディング＿現在地から住所取得
          const geocoder = new google.maps.Geocoder();
          geocoder.geocode({ location: pos }, (results, status) => {
            console.log("Geocoding結果:", status, results);

            if (status === "OK" && results[0]) {
              const address = results[0].formatted_address;
              console.log("取得した住所:", address);

              document.getElementById("address-input").value = address;
            } else {
              alert("住所の取得に失敗しました");
            }
          });
        },
        () => {
          alert("位置情報の取得に失敗しました。ブラウザの設定を確認してください。");
        }
      );
    } else {
      alert("お使いのブラウザは位置情報をサポートしていません");
    }
  });
});