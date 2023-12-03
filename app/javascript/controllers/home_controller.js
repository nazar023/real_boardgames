import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home"
export default class extends Controller {
  static targets = ["svgPath", "text1", "text2", "text3"]

  connect() {
    var length = this.svgPathTarget.getTotalLength()
    this.svgPathTarget.classList.remove('invisible')
    this.svgPathTarget.style.strokeDasharray = length;
    this.svgPathTarget.style.strokeDashoffset = length;
  }

  drawing()
  {
    length = this.svgPathTarget.getTotalLength()
    this.svgPathTarget.style.strokeDasharray = length;
    this.svgPathTarget.style.strokeDashoffset = length;
    var scrollpercent = (document.body.scrollTop + document.documentElement.scrollTop) / (document.documentElement.scrollHeight - document.documentElement.clientHeight);
    var draw = length * scrollpercent;
    // Reverse the drawing when scroll upwards
    this.svgPathTarget.style.strokeDashoffset = length - draw;
  }

  checking()
  {
    var windowHeight = window.innerHeight;
    var revealPoint = 1;

      var revealtop = this.text1Target.getBoundingClientRect().top;

      if (revealtop < windowHeight - revealPoint){
      this.text1Target.classList.add('fade-left')
      this.text1Target.classList.remove('opacity-0')
      }

      var revealtop = this.text2Target.getBoundingClientRect().top;

      if (revealtop < windowHeight - revealPoint) {
        this.text2Target.classList.add('fade-right')
        this.text2Target.classList.remove('opacity-0')
      }

      var revealtop = this.text3Target.getBoundingClientRect().top;

      if (revealtop < windowHeight - revealPoint) {
        this.text3Target.classList.add('fade-down')
        this.text3Target.classList.remove('opacity-0')
      }


  }
}
