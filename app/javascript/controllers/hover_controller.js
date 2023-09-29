import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["image"];

  static values = {
    avatar: String
  }

  mouseOver() {
    this.element.src = this.avatarValue;
    this.element.classList.add('opacity-70')
  }

  mouseOut() {
    this.element.classList.remove('opacity-70')
    this.element.src = "/assets/empty-spot.png";
  }
}
