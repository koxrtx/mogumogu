// ホームページの「現在地から探す」ボタン処理
// ボタン押したら画面遷移して現在地取得する
console.log("location.js読み込み")

document.addEventListener('turbo:load', function(){
console.log("発火2");

  const locationButton = document.getElementById("current-location-btn");
  console.log("locationButton:", locationButton);
    if (!locationButton) return; // 要素がなければ処理しない

  locationButton.addEventListener("click", () => {
    console.log("ボタンクリック")
    // ブラウザがユーザーの現在地（緯度・経度）を取得するためのAPI
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          const pos = {
            lat: position.coords.latitude,
            lng: position.coords.longitude,
          };

          // 画面遷移処理
          window.location.href = `/maps/search?lat=${pos.lat}&lng=${pos.lng}`;
        },

        // エラー処理
        () => {
          alert("位置情報の取得に失敗しました。ブラウザの設定を確認してください。");
        },
      );
    } else {
      // ブラウザが位置情報をサポートしていない場合
      alert("お使いのブラウザは位置情報をサポートしていません")
    }
  });
});

