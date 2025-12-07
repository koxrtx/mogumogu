import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fileInput", "helpText", "addField", "deleteField"]
  static values = {
    maxImages: Number,      // 最大3枚
    currentCount: Number    // 現在の登録枚数
  }

  connect() {
    console.log(`現在: ${this.currentCountValue}枚 / 最大: ${this.maxImagesValue}枚`)
    this.updateHelpText()
  }

  // 修正タイプ選択時
  changeType(event) {
    const requestType = event.target.value
    
    // 全フィールドを非表示
    this.addFieldTarget.classList.add("hidden")
    this.deleteFieldTarget.classList.add("hidden")

    // 選択された種別に応じて表示
    if (requestType === "add" || requestType === "both") {
      this.addFieldTarget.classList.remove("hidden")
      this.updateHelpText()
    }
    
    if (requestType === "remove" || requestType === "both") {
      this.deleteFieldTarget.classList.remove("hidden")
    }
  }

  // ファイル選択時のバリデーション
  validateFileCount(event) {
    const files = event.target.files
    const remaining = this.remainingCount()

    if (files.length > remaining) {
      alert(`追加できる画像は残り${remaining}枚です!✨`)
      event.target.value = "" // 選択をクリア
      return
    }

    // プレビュー表示(既存の関数を呼び出し)
    if (window.previewImage) {
      window.previewImage(event.target, 'image-preview-container')
    }
  }

  // 残り追加可能枚数を計算
  remainingCount() {
    return this.maxImagesValue - this.currentCountValue
  }

  // ヘルプテキストを更新
  updateHelpText() {
    if (!this.hasHelpTextTarget) return

    const remaining = this.remainingCount()
    
    if (remaining === 0) {
      this.helpTextTarget.textContent = "※ これ以上画像を追加できません(最大3枚)"
      this.helpTextTarget.classList.remove("text-pink-500")
      this.helpTextTarget.classList.add("text-red-500", "font-bold")
      
      // ファイル入力を無効化
      if (this.hasFileInputTarget) {
        this.fileInputTarget.disabled = true
      }
    } else {
      this.helpTextTarget.textContent = `※ あと${remaining}枚追加できます(最大3枚)`
      this.helpTextTarget.classList.remove("text-red-500", "font-bold")
      this.helpTextTarget.classList.add("text-pink-500")
      
      // ファイル入力を有効化
      if (this.hasFileInputTarget) {
        this.fileInputTarget.disabled = false
      }
    }
  }
}