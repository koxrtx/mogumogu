// 画像投稿プレビュー関数
document.addEventListener('turbo:load', () => {

  // 画像プレビュー関数をグローバルに登録（ビューから呼び出せるようにする）
  window.previewImage = (input, containerID) => {
    const files = input.files;
    const container = document.getElementById(containerID);
    // 既存のプレビュー画像を消してからにする
    container.innerHTML = '';

    // 各ファイルのループ処理
    Array.from(files).forEach(file => {
      const reader = new FileReader();

      // 読み込み完了したら実行される処理
      reader.onload = () => {
        const img = document.createElement('img');
        img.src = reader.result;
        img.classList.add('w-32', 'h-32', 'object-cover');
        container.appendChild(img);
      };

      // 画像を即時プレビュー可能にする
      reader.readAsDataURL(file);
    });
  };
});
