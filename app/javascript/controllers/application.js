import { Application } from "@hotwired/stimulus"
// stimulus-autocompleteライブラリをインポート
import AutocompleteController from "./autocomplete_controller"
import ModalController from "./modal_controller"
import ImageRequestController from "./image_request_controller"  // ← 名前を統一するため変更



const application = Application.start()
// オートコンプリート機能をStimulusに登録
application.register("autocomplete", AutocompleteController)
// モーダル機能をStimulusに登録
application.register("modal", ModalController)
// 写真修正（追加／削除 切り替え用コントローラ）
application.register("image-request", ImageRequestController)   // ← ここも名称統一！



// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }