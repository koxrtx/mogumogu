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

          window.location.href = `/maps/search?lat=${pos.lat}&lng=${pos.lng}`;
        },
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

