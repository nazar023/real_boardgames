import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["image"];

  static values = {
    avatar: String
  }

  async mouseOver() {
    this.imageTarget.classList.add("opacity-5")
    this.imageTarget.classList.remove("hover:opacity-10")
  }

  async mouseOut() {
    this.imageTarget.classList.remove("opacity-5")
    this.imageTarget.classList.add("hover:opacity-10")
  }
}
