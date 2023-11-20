import Dropdown from 'stimulus-dropdown'


export default class extends Dropdown {
  static targets = ["menu"]

  connect() {
    super.connect()
    // console.log('Hello Controller')
    // console.log(this.menuTarget)
    // this.element.classList.add('invisible');
  }

  toggle(event) {
    super.toggle()
  }

  hide(event) {
    super.hide(event)
  }

  greet() {
    console.log(this.outputTarget)
    console.log(this.nameTarget)
    this.outputTarget.textContent =
      `Hello, ${this.nameTarget.value}!`
  }
}
