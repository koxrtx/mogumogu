// 現在地から住所反映ボタンおした時に住所欄に現在地を取得して反映させるjs

document.addEventListener('turbo:load', function(){
  // console.log("Turbo:load 発火");

  const locationButton = document.getElementById("current-address-btn");

  if (!locationButton) return;

  // ボタンを押した時の処理
  locationButton.addEventListener("click", () => {
    // console.log("ボタンクリック検知");

    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          const pos = {
            lat: position.coords.latitude,
            lng: position.coords.longitude,
          };
          // console.log("位置情報取得:", pos);

          // 逆ジオコーディング＿現在地から住所取得
          const geocoder = new google.maps.Geocoder();
          geocoder.geocode({ location: pos }, (results, status) => {
            // console.log("Geocoding結果:", status, results);

            if (status === "OK" && results[0]) {
              const address = results[0].formatted_address;
              // console.log("取得した住所:", address);

              const addressInput = document.getElementById("address-input");
              // console.log("住所入力欄の要素:", addressInput);
              
              // ここが追加部分！
              if (addressInput) {
                // console.log("✅ addressInputが存在します");
                
                // 値を設定
                addressInput.value = address;
                // console.log("設定後の値:", addressInput.value);
                
                // フォームに変更を認識させる
                addressInput.dispatchEvent(new Event('input', { bubbles: true }));
                addressInput.dispatchEvent(new Event('change', { bubbles: true }));
                
                // console.log("イベント発火完了");
              } else {
                // console.log("❌ addressInputが見つかりません");
              }
              
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