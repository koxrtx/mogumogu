console.log("hamburger.js読み込み完了");

document.addEventListener("turbo:load", function() {
  console.log("turbo:load - ハンバーガーメニュー初期化開始");
  
  const hamburger = document.querySelector(".hamburger");
  const nav = document.querySelector(".nav");
  
  if (!hamburger || !nav) {
    console.log("ハンバーガーメニュー要素が見つかりません");
    return;
  }
  
  console.log("ハンバーガーメニュー要素を発見、イベントリスナー設定中");
  
  // 既存のイベントリスナーを削除（重複防止）
  hamburger.removeEventListener("click", handleHamburgerClick);
  
  // ハンバーガーメニューのクリックイベント
  function handleHamburgerClick() {
    console.log("ハンバーガーメニューがクリックされました");
    
    hamburger.classList.toggle("active");
    nav.classList.toggle("active");
    
    // アクセシビリティ対応
    const isOpen = hamburger.classList.contains("active");
    hamburger.setAttribute("aria-expanded", isOpen);
    nav.setAttribute("aria-hidden", !isOpen);
    
    console.log("メニュー状態:", isOpen ? "開く" : "閉じる");
  }
  
  hamburger.addEventListener("click", handleHamburgerClick);
  
  // メニューの外側をクリックした時の処理
  function handleOutsideClick(e) {
    if (!e.target.closest(".nav") && !e.target.closest(".hamburger") && nav.classList.contains("active")) {
      hamburger.classList.remove("active");
      nav.classList.remove("active");
      hamburger.setAttribute("aria-expanded", false);
      nav.setAttribute("aria-hidden", true);
      console.log("メニュー外クリックでメニューを閉じました");
    }
  }
  
  // 既存のイベントリスナーを削除してから追加
  document.removeEventListener("click", handleOutsideClick);
  document.addEventListener("click", handleOutsideClick);
  
  console.log("ハンバーガーメニュー初期化完了");
});
