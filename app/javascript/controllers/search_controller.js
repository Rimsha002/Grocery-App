import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "filters"]
  static values = {
    url: String,
    minPrice: Number,
    maxPrice: Number
  }

  connect() {
    this.timeout = null
    this.bindEvents()
  }

  bindEvents() {
    this.inputTarget.addEventListener('input', () => {
      clearTimeout(this.timeout)
      this.timeout = setTimeout(() => this.search(), 300)
    })
  }

  search() {
    const query = this.inputTarget.value
    if (query.length < 2) {
      this.resultsTarget.innerHTML = ''
      return
    }

    const filters = this.getFilters()
    
    fetch(`${this.urlValue}?query=${encodeURIComponent(query)}&${new URLSearchParams(filters)}`)
      .then(response => response.json())
      .then(data => {
        this.resultsTarget.innerHTML = this.buildResults(data)
      })
  }

  getFilters() {
    const filters = {}
    if (this.hasFiltersTarget) {
      const formData = new FormData(this.filtersTarget)
      for (let [key, value] of formData.entries()) {
        filters[key] = value
      }
    }
    return filters
  }

  buildResults(data) {
    if (!data.products || data.products.length === 0) {
      return '<div class="p-4 text-gray-500">No products found</div>'
    }

    return data.products.map(product => `
      <a href="/products/${product.id}" class="block hover:bg-gray-50">
        <div class="flex items-center p-4">
          <img src="${product.image_url}" alt="${product.name}" class="w-16 h-16 object-cover rounded">
          <div class="ml-4">
            <h3 class="font-medium text-gray-900">${product.name}</h3>
            <p class="text-sm text-gray-500">${product.category}</p>
            <p class="text-sm font-medium text-green-600">$${product.price}</p>
          </div>
        </div>
      </a>
    `).join('')
  }

  filterChanged() {
    this.search()
  }
} 