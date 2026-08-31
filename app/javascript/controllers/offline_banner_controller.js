import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.sync = this.sync.bind(this)
    this.sync()
    window.addEventListener("offline", this.sync)
    window.addEventListener("online", this.sync)
  }

  disconnect() {
    window.removeEventListener("offline", this.sync)
    window.removeEventListener("online", this.sync)
  }

  sync() {
    this.element.hidden = navigator.onLine
  }
}
