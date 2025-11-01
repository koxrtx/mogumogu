import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]
  static values = { url: String }

  async search() {
    const query = this.inputTarget.value.trim()
    
    if (query.length < 2) {
      this.hideResults()
      return
    }

    try {
      const response = await fetch(`${this.urlValue}?q=${query}`)
      const results = await response.json()
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
        this.inputTarget.form.submit()
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