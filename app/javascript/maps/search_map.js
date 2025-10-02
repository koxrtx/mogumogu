import { buildFacilityInfo} from "./facility_info";

let map, infoWindow;

document.addEventListener('turbo:load',async function(){
  console.log('=== デバッグ開始 ===');
  console.log('spots変数チェック:', typeof spots, spots);

  // もしspotsが未定義なら、別の方法で取得を試す
  if (typeof spots === 'undefined') {
    console.log('spots変数が定義されていません！');
    console.log('window.spots:', typeof window.spots, window.spots);
    return; // ここで処理を止める
  }

  const { Map } = await google.maps.importLibrary("maps");
  const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");

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
    mapId: mapId
  });
  infoWindow = new google.maps.InfoWindow();

  const currentPosition = { lat: lat, lng: lng };

  // マップに表示する内容
  infoWindow.setPosition(currentPosition);
  infoWindow.setContent("現在地");
  infoWindow.open(map);
  map.setCenter(currentPosition);

  // ユーザーが投稿した内容をマーカーでマップに反映
  if (typeof spots !== 'undefined' && spots !== null && Array.isArray(spots) && spots.length > 0) {

    spots.forEach(spot => {

      console.log('spots:', spots)

      const marker = new google.maps.marker.AdvancedMarkerElement ({
        position: { lat: Number(spot.latitude), lng: Number(spot.longitude) },
        map: map,
        title: spot.name
      });

      const infoWindowPost = new google.maps.InfoWindow({
        content: `<div>
                    <strong>${spot.name}</strong><br>
                    ${spot.address}<br>
                    ${buildFacilityInfo(spot)}
                  </div>`
      });
      marker.addListener("click", () => infoWindowPost.open(map, marker));
    });
  }
})
