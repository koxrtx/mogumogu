document.addEventListener('DOMContentLoaded', function() {
  const agreementCheck = document.getElementById('agreement_check');
  const registerButton = document.getElementById('register_button');
  
  if (agreementCheck && registerButton) {
    // 初期状態：ボタンを無効化
    registerButton.disabled = true;
    
    agreementCheck.addEventListener('change', function() {
      registerButton.disabled = !this.checked;
    });
  }
});