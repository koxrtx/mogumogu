let map, infoWindow;
console.log("search_map.js読み込み")

document.addEventListener('turbo:load',async function(){

  const { Map } = await google.maps.importLibrary("maps");

  if (typeof google === 'undefined'){
  // GoogleMAP APIが読み込まれているか
    console.log('Google Maps APIが読み込まれていません');
    return;
}

// URLパラメーターから位置情報を取得
  // デフォルトは東京駅
  const urlParams = new URLSearchParams(window.location.search);
  const lat = parseFloat(urlParams.get('lat')) || 35.68114;
  const lng = parseFloat(urlParams.get('lng')) || 139.767061;

  map = new google.maps.Map(document.getElementById("map"), {
    center: { lat: lat, lng: lng },
    zoom: 15,
  });
  infoWindow = new google.maps.InfoWindow();

  const currentPosition = { lat: lat, lng: lng };

  infoWindow.setPosition(currentPosition);
  infoWindow.setContent("現在地");
  infoWindow.open(map);
  map.setCenter(currentPosition);

})
