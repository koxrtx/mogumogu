document.addEventListener('turbo:load', function() {
  //console.log('turbo:load発火'); // ← デバッグ用
  
  const agreementCheck = document.getElementById('agreement_check');
  const registerButton = document.getElementById('register_button');
  
  // console.log('agreementCheck:', agreementCheck);
  // console.log('registerButton:', registerButton);
  
  if (agreementCheck && registerButton) {
    // 初期状態：ボタンを無効化
    registerButton.disabled = true;
    console.log('初期設定完了');
    
    agreementCheck.addEventListener('change', function() {
      console.log('changeイベント発火！チェック状態:', this.checked);
      registerButton.disabled = !this.checked;
      console.log('ボタンdisabled設定:', registerButton.disabled);
    });
  } else {
    // console.log('要素が見つかりません');
  }
});