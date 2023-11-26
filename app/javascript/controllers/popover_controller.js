import { Controller } from "@hotwired/stimulus";
import { useTransition } from 'stimulus-use';

export default class extends Controller {

  static targets = ["card"]


  connect() {
    super.connect()
  }

  show()
  {
    this.cardTarget.classList.remove("opacity-0");
  }

  hide()
  {
    this.cardTarget.classList.add("opacity-0");

  }

  disconnect()
  {
    super.disconnect()
    if (this.hasCardTarget) {
      this.cardTarget.remove()
    }
  }
}
