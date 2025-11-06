// ユーザー登録前の利用規約とプライバシーポリシー画面のモーダル処理
// ユーザー登録前の利用規約とプライバシーポリシー画面のモーダル処理
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["frame"]

  connect() {
    // ESCキーで閉じる
    document.addEventListener("keydown", this.escClose.bind(this))
  }

  disconnect() {
    document.removeEventListener("keydown", this.escClose.bind(this))
  }

  open(event) {
    event.preventDefault()
    const url = event.currentTarget.getAttribute("href")
    const modal = this.element.querySelector('.fixed.inset-0')
    
    this.frameTarget.src = url    // Turbo Frame に読み込む
    modal.classList.remove("hidden")  // モーダル表示
    document.body.classList.add("overflow-hidden")

    // ここでスクロール位置をトップにリセット
    this.frameTarget.scrollTop = 0
  }

  close() {
    const modal = this.element.querySelector('.fixed.inset-0')
    modal.classList.add("hidden")
    this.frameTarget.scrollTop = 0
    this.frameTarget.src = ""    // 内容をクリア
    document.body.classList.remove("overflow-hidden")
  }

  // 背景クリックでモーダルを閉じる（モーダルコンテンツ内のクリックは除外）
  stopPropagation(event) {
    event.stopPropagation()
  }

  escClose(e) {
    if (e.key === "Escape") {
      const modal = this.element.querySelector('.fixed.inset-0')
      if (modal && !modal.classList.contains("hidden")) {
        this.close()
      }
    }
  }
}