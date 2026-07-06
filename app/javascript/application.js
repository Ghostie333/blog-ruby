// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import "trix"
import "@rails/actiontext"

// Funkcja obsługująca wysuwanie i automatyczne chowanie powiadomień flash
const setupFlashToasts = () => {
  document.querySelectorAll('.flash-toast').forEach((toast) => {

    toast.addEventListener('click', () => {
      toast.classList.add('translate-x-full', 'opacity-0');
      setTimeout(() => { toast.remove(); }, 300);
    });
    
    // 1. Płynny wjazd pop-upa na ekran
    setTimeout(() => {
      toast.classList.remove('translate-x-full', 'opacity-0');
    }, 100);

    // 2. Wyjazd z ekranu po 4 sekundach (4000ms)
    setTimeout(() => {
      toast.classList.add('translate-x-full', 'opacity-0');
      
      // 3. Całkowite usunięcie elementu z widoku po zakończeniu animacji
      setTimeout(() => { toast.remove(); }, 300);
    }, 4000);
  });
};

// Rejestracja zdarzeń dla klasycznego ładowania stron oraz dla Turbo Drive
document.addEventListener('DOMContentLoaded', setupFlashToasts);
document.addEventListener('turbo:load', setupFlashToasts);