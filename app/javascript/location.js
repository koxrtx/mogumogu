// ホーム画面ボタンとヘッダーのリンク両方に
// moveToCurrentLpcationを実行するイベントをつける
// 現在地から検索ボタン押したら、現在地を取得してその場所の地図ページに移動させるjs
// 地図の表示はmaps/search_map.jsで行う
document.addEventListener('turbo:load', function() {
  const locationButton = document.getElementById("current-location-btn");
  const locationLink = document.getElementById("current-location-link");

  if (locationButton) locationButton.addEventListener("click", moveToCurrentLocation);
  if (locationLink) locationLink.addEventListener("click", moveToCurrentLocation);
});

// 現在地取得
function moveToCurrentLocation(event) {
  if (event) event.preventDefault(); // リンクの場合はページ遷移を止める

  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(
      (position) => {
        const pos = {
          lat: position.coords.latitude,
          lng: position.coords.longitude,
        };
        // 画面遷移
        window.location.href = `/maps/search?lat=${pos.lat}&lng=${pos.lng}`;
      },
      // エラー処理
      () => {
        alert("位置情報の取得に失敗しました。ブラウザの設定を確認してください。");
      }
    );
  } else {
    // ブラウザが位置情報をサポートしていない場合
    alert("お使いのブラウザは位置情報をサポートしていません");
  }
}

