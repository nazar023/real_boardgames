import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home"
export default class extends Controller {
  static targets = ["leftEye", "eye"]

  connect() {
    document.addEventListener('mousemove',(e) => {
      this.eyeTargets.forEach(eye => {
        let x = (eye.getBoundingClientRect().left) + (eye.clientWidth / 2)
        let y = (eye.getBoundingClientRect().top) + (eye.clientHeight / 2)

        let radian = Math.atan2(e.pageX - x , e.pageY - y);
        let rotation = (radian * (180 / Math.PI) * - 1)

        eye.style.transform = `rotate(${rotation}deg)`
      });
    })
  }

  appear()
  {
    this.element.classList.add("fire-out-animation")
    this.element.classList.remove("translate-y-32")
  }
}
