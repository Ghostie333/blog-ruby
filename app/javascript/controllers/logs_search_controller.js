import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  filterLogs() {
    // Usuwamy poprzedni timer
    clearTimeout(this.timeout)

    // Wysyłamy zapytanie po 250ms zamiast co każdą zmiane w inpucie
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, 250)
  }
}