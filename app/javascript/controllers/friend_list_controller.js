import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["drawer", "friendList"]

  open() {
    this.drawerTarget.classList.remove("translate-x-full")
    this.friendListTarget.classList.remove("hidden")
  }

  close() {
    this.drawerTarget.classList.add("translate-x-full")
    this.friendListTarget.classList.add("hidden")
  }
}