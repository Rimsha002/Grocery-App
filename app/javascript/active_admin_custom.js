document.addEventListener('DOMContentLoaded', function() {
  // Add animations to panels
  const panels = document.querySelectorAll('.panel');
  panels.forEach((panel, index) => {
    panel.style.opacity = '0';
    panel.style.transform = 'translateY(20px)';
    panel.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
    
    setTimeout(() => {
      panel.style.opacity = '1';
      panel.style.transform = 'translateY(0)';
    }, 100 * index);
  });
  
  // Enhance form inputs with subtle animations
  const formInputs = document.querySelectorAll('input, textarea, select');
  formInputs.forEach(input => {
    input.addEventListener('focus', function() {
      this.style.transition = 'all 0.2s ease';
      this.style.transform = 'translateY(-2px)';
      this.style.boxShadow = '0 4px 6px rgba(0, 0, 0, 0.1)';
    });
    
    input.addEventListener('blur', function() {
      this.style.transform = 'translateY(0)';
      this.style.boxShadow = 'none';
    });
  });
});