import { Controller } from "@hotwired/stimulus"

// Stimulus控制器
export default class extends Controller {
  connect() {
    console.log("Hello controller connected")
  }
}
