// LINE ログインボタンの画像を、状態（通常・ホバー・押した時）によって切り替えるjs
document.addEventListener("turbo:load", () => {
  const button = document.getElementById('line-login-btn');
  const icon = document.getElementById('line-icon-official');
  if (!button || !icon) return;

  const baseSrc = button.dataset.baseImage;
  const hoverSrc = button.dataset.hoverImage;
  const pressSrc = button.dataset.pressImage;

  // ホバー時
  button.addEventListener('mouseenter', () => {
    icon.src = hoverSrc;
  });

  // プレス時
  button.addEventListener('mousedown', () => {
    icon.src = pressSrc;
  });

  // マウスアップ時
  button.addEventListener('mouseup', () => {
    icon.src = hoverSrc;
  });

  // マウスが離れた時
  button.addEventListener('mouseleave', () => {
    icon.src = baseSrc;
  });
});