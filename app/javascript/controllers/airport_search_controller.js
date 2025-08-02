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
      .then(response => response.json())
      .then(airports => {
        optionsTarget.innerHTML = this.buildOptions(airports)
        if (airports.length > 0) {
          optionsTarget.showPopover()
        }
      })
      .catch(error => {
        console.error("Error fetching airports:", error)
        optionsTarget.innerHTML = ""
        optionsTarget.hidePopover()
      })
  }

  buildOptions(airports) {
    return airports.map(airport => 
      `<el-option value="${airport.iata_code}" class="block px-4 py-3 text-sm text-gray-900 hover:bg-blue-50 hover:text-blue-700 focus:bg-blue-50 focus:text-blue-700 focus:outline-none cursor-pointer transition-colors duration-150 ease-in-out">
        <div class="font-medium">${airport.name}</div>
        <div class="text-gray-500 text-xs">${airport.iata_code} - ${airport.city}, ${airport.country}</div>
      </el-option>`
    ).join("")
  }
}