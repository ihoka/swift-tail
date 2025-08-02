import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["from", "to", "fromOptions", "toOptions"]
  static values = { url: String }

  connect() {
    this.urlValue = "/airports"
  }

  searchFrom(event) {
    this.search(event.target.value, this.fromOptionsTarget)
  }

  searchTo(event) {
    this.search(event.target.value, this.toOptionsTarget)
  }

  search(query, optionsTarget) {
    if (query.length < 2) {
      optionsTarget.innerHTML = ""
      optionsTarget.hidePopover()
      return
    }

    const url = new URL(this.urlValue, window.location.origin)
    url.searchParams.set("query", query)

    fetch(url)
      .then(response => response.text())
      .then(html => {
        optionsTarget.innerHTML = html
        if (html.trim().length > 0) {
          optionsTarget.showPopover()
        }
      })
      .catch(error => {
        console.error("Error fetching airports:", error)
        optionsTarget.innerHTML = ""
        optionsTarget.hidePopover()
      })
  }

}