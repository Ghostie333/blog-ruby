import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toast"
export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.dismiss()
    }, 2000)
  }

  dismiss() {
    this.element.classList.add("opacity-0", "translate-x-full")

    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}
