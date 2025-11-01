import { Application } from "@hotwired/stimulus"
// stimulus-autocompleteライブラリをインポート
import { Autocomplete } from 'stimulus-autocomplete'

const application = Application.start()
// オートコンプリート機能をStimulusに登録
application.register('autocomplete', Autocomplete)


// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
