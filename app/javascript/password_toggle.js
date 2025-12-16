// クリック委任でどのページでも動く
// パスワード表示・非表示切り替え機能
document.addEventListener("click", (e) => {
  const btn = e.target.closest(".password-toggle-btn");
  if (!btn) return;

  const fieldId = btn.dataset.target;
  const field = document.getElementById(fieldId);
  if (!field) return;

  const eyeOn  = btn.querySelector(".eye-on");
  const eyeOff = btn.querySelector(".eye-off");

  const reveal = field.type === "password";
  field.type = reveal ? "text" : "password";

  // アイコン切り替え
  if (eyeOn && eyeOff) {
    eyeOn.classList.toggle("hidden", reveal);
    eyeOff.classList.toggle("hidden", !reveal);
  }
});