import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "results", "count"]
  static values = {
    url: String
  }

  connect() {
    this.debouncedFilter = this.debounce(this.filter.bind(this), 300)
  }

  filter() {
    const formData = new FormData(this.formTarget)
    const params = new URLSearchParams(formData)
    const url = `${this.urlValue}?${params.toString()}`

    fetch(url, {
      headers: {
        "Accept": "application/json",
        "X-Requested-With": "XMLHttpRequest"
      }
    })
    .then(response => response.json())
    .then(data => {
      this.resultsTarget.innerHTML = data.html
      this.countTarget.textContent = data.count
      history.pushState({}, '', url)
    })
  }

  debounce(func, wait) {
    let timeout
    return function executedFunction(...args) {
      const later = () => {
        clearTimeout(timeout)
        func(...args)
      }
      clearTimeout(timeout)
      timeout = setTimeout(later, wait)
    }
  }

  // Handle price range inputs
  priceChange() {
    this.debouncedFilter()
  }

  // Handle category selection
  categoryChange() {
    this.filter()
  }

  // Handle brand selection
  brandChange() {
    this.filter()
  }

  // Handle sorting
  sortChange(event) {
    const [sort, direction] = event.target.value.split('-')
    const formData = new FormData(this.formTarget)
    formData.set('sort', sort)
    formData.set('direction', direction)
    this.filter()
  }

  // Handle stock filter
  stockChange() {
    this.filter()
  }

  // Handle rating filter
  ratingChange() {
    this.filter()
  }

  // Handle search input
  search(event) {
    const query = event.target.value.trim()
    if (query.length >= 2 || query.length === 0) {
      this.debouncedFilter()
    }
  }
}