import { Application } from "@hotwired/stimulus"
// stimulus-autocompleteライブラリをインポート
import AutocompleteController from "./autocomplete_controller"
import ModalController from "./modal_controller"



const application = Application.start()
// オートコンプリート機能をStimulusに登録
application.register("autocomplete", AutocompleteController)
// モーダル機能をStimulusに登録
application.register("modal", ModalController)



// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
