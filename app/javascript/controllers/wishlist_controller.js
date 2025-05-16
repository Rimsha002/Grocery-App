import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]
  static values = {
    productId: Number,
    inWishlist: Boolean
  }

  connect() {
    this.updateButtonState()
  }

  toggle(event) {
    event.preventDefault()
    
    const url = this.inWishlistValue ? 
      `/wishlist_items/${this.productIdValue}` : 
      '/wishlist_items'

    const method = this.inWishlistValue ? 'DELETE' : 'POST'
    const body = method === 'POST' ? JSON.stringify({ product_id: this.productIdValue }) : null

    fetch(url, {
      method: method,
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: body
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        this.inWishlistValue = !this.inWishlistValue
        this.updateButtonState()
      }
    })
  }

  updateButtonState() {
    const button = this.buttonTarget
    if (this.inWishlistValue) {
      button.classList.remove('text-gray-400', 'hover:text-red-500')
      button.classList.add('text-red-500')
      button.querySelector('svg').classList.add('fill-current')
    } else {
      button.classList.add('text-gray-400', 'hover:text-red-500')
      button.classList.remove('text-red-500')
      button.querySelector('svg').classList.remove('fill-current')
    }
  }
} 