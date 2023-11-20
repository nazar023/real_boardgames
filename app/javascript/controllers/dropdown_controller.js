import Dropdown from 'stimulus-dropdown'

export default class extends Dropdown {

  connect() {
    super.connect()
    console.log('Connected!!!')

  }

  toggle(event) {
    super.toggle()
    console.log('on')
  }

  hide(event) {
    super.hide(event)
    super.TargetMenu.hide(event)
    console.log('off  ')
  }
}
