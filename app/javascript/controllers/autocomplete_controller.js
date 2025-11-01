import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]
  static values = { url: String }

  async search() {

    console.log("searchメソッド呼ばれた")


    const query = this.inputTarget.value.trim()
    
    if (query.length < 2) {
      this.hideResults()
      return
    }

    try {
    // Rails Ransack用に q[name_cont] パラメータで送信
    const url = new URL(this.urlValue, window.location.origin)
    url.searchParams.append("q[name_or_address_cont]", query)

    const response = await fetch(url)
    const results = await response.json()

    console.log("検索結果:", results)

    this.displayResults(results)
  } catch (error) {
    console.error("検索エラー:", error)
  }
}

  displayResults(results) {
    this.resultsTarget.innerHTML = ""
    
    results.forEach(result => {
      const li = document.createElement("li")
      li.textContent = result.label
      li.addEventListener("click", () => {
        this.inputTarget.value = result.value
        this.hideResults()
      })
      this.resultsTarget.appendChild(li)
    })
    
    this.showResults()
  }

  showResults() {
    this.resultsTarget.classList.remove("hidden")
  }

  hideResults() {
    this.resultsTarget.classList.add("hidden")
  }
}