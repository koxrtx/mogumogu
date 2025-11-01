import { Application } from "@hotwired/stimulus"
// stimulus-autocompleteライブラリをインポート
import AutocompleteController from "./autocomplete_controller"


const application = Application.start()
// オートコンプリート機能をStimulusに登録
application.register("autocomplete", AutocompleteController)


// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
