import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets() {
    return [ "menuContainer", "icon" ]
  }

  toggle() {
    if (this.menuContainerTarget.dataset.expanded === "1") {
      this.collapse()
    } else {
      this.expand()
    }
  }

  collapse() {
    this.menuContainerTarget.classList.add("hidden")
    this.iconTarget.innerHTML = `
      <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewbox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
      </svg>
    `
    this.menuContainerTarget.dataset.expanded = "0"
  }

  expand() {
    this.menuContainerTarget.classList.remove("hidden")
    this.iconTarget.innerHTML = `
      <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewbox="0 0 24 24" stroke="currentColor" stroke-width="2">
        <path fill="none" d="M6.25,6.25,17.75,17.75" />
        <path fill="none" d="M6.25,17.75,17.75,6.25" />
      </svg>
    `
    this.menuContainerTarget.dataset.expanded = "1"
  }

}
