import { Controller } from "@hotwired/stimulus"

// Stimulus controller
export default class extends Controller {
  connect() {
    console.log("Hello controller connected")
  }
}
