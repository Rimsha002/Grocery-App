import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["quantity", "total", "item"]
  static values = {
    price: Number,
    id: Number
  }

  connect() {
    this.updateTotal()
  }

  increment(event) {
    event.preventDefault()
    const input = this.quantityTarget
    input.value = parseInt(input.value) + 1
    this.updateQuantity()
  }

  decrement(event) {
    event.preventDefault()
    const input = this.quantityTarget
    const newValue = parseInt(input.value) - 1
    if (newValue >= 1) {
      input.value = newValue
      this.updateQuantity()
    }
  }

  updateQuantity() {
    const quantity = parseInt(this.quantityTarget.value)
    const itemId = this.idValue

    fetch(`/cart_items/${itemId}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ quantity: quantity })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        this.updateTotal()
      }
    })
  }

  remove(event) {
    event.preventDefault()
    const itemId = this.idValue

    fetch(`/cart_items/${itemId}`, {
      method: 'DELETE',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      }
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        this.itemTarget.remove()
        this.dispatch("itemRemoved")
      }
    })
  }

  updateTotal() {
    const quantity = parseInt(this.quantityTarget.value)
    const total = (this.priceValue * quantity).toFixed(2)
    this.totalTarget.textContent = `$${total}`
  }
} 