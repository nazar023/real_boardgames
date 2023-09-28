import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["image"];

  connect(){
  }

  mouseOver() {
    this.element.src = "/assets/guestavatar1.png";
  }

  mouseOut() {
    this.element.src = "/assets/empty-spot.png";
  }
}
