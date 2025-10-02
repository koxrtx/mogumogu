export function buildFacilityInfo(spot) {
  let info = [];

  if (spot.child_chair) info.push("子供椅子あり");
  if (spot.tatami_seat) info.push("座敷あり");
  if (spot.child_tableware) info.push("子供用食器あり");
  if (spot.bring_baby_food) info.push("離乳食持ち込み可");
  if (spot.stroller_ok) info.push("ベビーカーOK");
  if (spot.child_menu) info.push("子供メニューあり");
  if (spot.parking) info.push("駐車場あり");
  if (spot.other_facility) info.push("その他設備あり");

  return info.length > 0 ? info.join(" / ") : "施設情報なし";
}