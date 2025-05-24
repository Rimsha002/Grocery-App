import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.imagePreviewContainer = this.element.querySelector("#image-preview")
  }

  previewImages(event) {
    const files = event.target.files
    
    for (const file of files) {
      if (file.type.startsWith('image/')) {
        const reader = new FileReader()
        
        reader.onload = (e) => {
          const preview = this.createImagePreview(e.target.result)
          this.imagePreviewContainer.appendChild(preview)
        }
        
        reader.readAsDataURL(file)
      }
    }
  }

  createImagePreview(src) {
    const div = document.createElement('div')
    div.className = 'relative'
    
    const img = document.createElement('img')
    img.src = src
    img.className = 'w-full h-48 object-cover rounded-lg'
    
    const button = document.createElement('button')
    button.type = 'button'
    button.className = 'absolute top-2 right-2 bg-red-500 text-white rounded-full p-1 hover:bg-red-600'
    button.innerHTML = `
      <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
      </svg>
    `
    button.addEventListener('click', () => div.remove())
    
    div.appendChild(img)
    div.appendChild(button)
    
    return div
  }

  removeImage(event) {
    const imageId = event.currentTarget.dataset.imageId
    if (!imageId) return

    // Send DELETE request to remove the image
    fetch(`/products/remove_image/${imageId}`, {
      method: 'DELETE',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
      },
    }).then(response => {
      if (response.ok) {
        event.currentTarget.closest('.relative').remove()
      }
    })
  }
}