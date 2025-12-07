import { Controller } from "@hotwired/stimulus"

// 「追加・削除・両方」 をえらんだときに、必要な入力フォームだけを表示する役わり
export default class extends Controller {

  // addField と deleteField を使えるようにする
  // addFieldTarget → 写真を追加する入力欄
  // deleteFieldTarget → 写真を削除する入力欄
  static targets = ["addField", "deleteField"]

  // セレクトボックスが変更されたときに実行される
  changeType(event) {
    const type = event.target.value

    // 全部隠す（まず隠す）
    this.addFieldTarget.classList.add("hidden")
    this.deleteFieldTarget.classList.add("hidden")

    // 追加
    if (type === "add") {
      this.addFieldTarget.classList.remove("hidden")
    }

    // 削除
    if (type === "delete") {
      this.deleteFieldTarget.classList.remove("hidden")
    }

    // 追加＋削除
    if (type === "both") {
      this.addFieldTarget.classList.remove("hidden")
      this.deleteFieldTarget.classList.remove("hidden")
    }
  }
}