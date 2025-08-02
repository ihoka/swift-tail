import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["from", "to", "fromOptions", "toOptions"]
  static values = { url: String }

  connect() {
    this.urlValue = "/airports"
    this.handleClickOutside = this.handleClickOutside.bind(this)
    document.addEventListener("click", this.handleClickOutside)
    this.isSelecting = false
  }

  disconnect() {
    document.removeEventListener("click", this.handleClickOutside)
  }

  searchFrom(event) {
    if (this.isSelecting) return
    this.search(event.target.value, this.fromOptionsTarget)
  }

  searchTo(event) {
    if (this.isSelecting) return
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
          this.attachOptionClickHandlers(optionsTarget)
        }
      })
      .catch(error => {
        console.error("Error fetching airports:", error)
        optionsTarget.innerHTML = ""
        optionsTarget.hidePopover()
      })
  }

  attachOptionClickHandlers(optionsTarget) {
    const options = optionsTarget.querySelectorAll("el-option")
    options.forEach(option => {
      option.addEventListener("click", (event) => {
        event.preventDefault()
        event.stopPropagation()
        this.selectOption(event, optionsTarget)
      })
    })
  }

  selectOption(event, optionsTarget) {
    const option = event.currentTarget
    const value = option.getAttribute("value")
    const displayText = option.querySelector(".font-medium").textContent

    const inputTarget = optionsTarget === this.fromOptionsTarget ? this.fromTarget : this.toTarget

    this.isSelecting = true
    inputTarget.value = `${displayText} (${value})`

    optionsTarget.hidePopover()
    optionsTarget.innerHTML = ""

    // Timeout prevents search from running when input value changes
    // Input events can fire asynchronously after setting the value
    setTimeout(() => {
      this.isSelecting = false
    }, 100)
  }

  handleClickOutside(event) {
    const fromOptionsOpen = this.fromOptionsTarget.matches(':popover-open')
    const toOptionsOpen = this.toOptionsTarget.matches(':popover-open')

    if (!fromOptionsOpen && !toOptionsOpen) return

    const clickedInsideFrom = this.fromTarget.contains(event.target) || this.fromOptionsTarget.contains(event.target)
    const clickedInsideTo = this.toTarget.contains(event.target) || this.toOptionsTarget.contains(event.target)

    if (!clickedInsideFrom && fromOptionsOpen) {
      this.fromOptionsTarget.hidePopover()
      this.fromOptionsTarget.innerHTML = ""
    }

    if (!clickedInsideTo && toOptionsOpen) {
      this.toOptionsTarget.hidePopover()
      this.toOptionsTarget.innerHTML = ""
    }
  }

}
