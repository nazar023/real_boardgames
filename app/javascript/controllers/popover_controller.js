import { Controller } from "@hotwired/stimulus";
import { useTransition } from 'stimulus-use';

export default class extends Controller {

  static targets = ["card"]


  connect() {
    super.connect()
  }

  show()
  {
    var card = this.cardTarget
    setTimeout(() => { card.classList.remove("invisible"); }, 10);
    card.classList.remove("opacity-0");
  }

  hide()
  {
    var card = this.cardTarget
    card.classList.add("opacity-0");
    setTimeout(() => { card.classList.add("invisible"); }, 410);

  }

  disconnect()
  {
    super.disconnect()
    if (this.hasCardTarget) {
      this.cardTarget.remove()
    }
  }
}
