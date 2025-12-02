// ユーザー登録前に「利用規約を開いて → 同意チェック」しないと登録できないJS
document.addEventListener('turbo:load', function() {
  //console.log('turbo:load発火');
  // チェックボックス（同意チェック）
  const agreementCheck = document.getElementById('agreement_check');
  // 登録ボタン
  const registerButton = document.getElementById('register_button');
  // 利用規約リンク
  const termsLink = document.getElementById('terms_link');
  
  // console.log('agreementCheck:', agreementCheck);
  // console.log('registerButton:', registerButton);
  
  // 利用規約のリンクを開く・チェックボックスにチェックする・登録ボタンを押すをしない場合は何もしない
  if (!agreementCheck || !registerButton || !termsLink) return;

  // --- 初期状態 ---
  // チェックボックスはチェックできない・登録ボタンも押せない
  agreementCheck.disabled = true;
  registerButton.disabled = true;

  // 利用規約をクリックしたらチェックできるようにする
  termsLink.addEventListener('click', function() {
    agreementCheck.disabled = false;
  });

  // チェックが入ったらボタンが押せるようになる
  agreementCheck.addEventListener('change', function() {
    registerButton.disabled = !this.checked;
  });
});