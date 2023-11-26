import { Controller } from "@hotwired/stimulus";
import { useTransition } from 'stimulus-use';

export default class extends Controller {

  static targets = ["card"]


  connect() {
    super.connect()

    console.log("helloooo")
  }

  show()
  {
    this.cardTarget.classList.remove("opacity-0");
    console.log("remove hiden!")
  }

  hide()
  {
    this.cardTarget.classList.add("opacity-0");

  }

  disconnect()
  {
    super.disconnect()
    console.log(this.cardTarget)
    if (this.hasCardTarget) {
      this.cardTarget.remove()
    }
  }
}
