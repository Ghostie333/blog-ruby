# 🚀 Ruby on Rails Community Blog

Nowoczesna, skonteneryzowana aplikacja społecznościowo-blogowa napisana w **Ruby on Rails**. Projekt skupia się na dostarczeniu płynnego interfejsu użytkownika (UX) bez zbędnego przeładowywania stron, wykorzystując **Hotwire (Turbo)** oraz elastyczność **Dockera**.

---

## 🛠️ Stack Technologiczny

*   **Backend:** Ruby on Rails 7.x, PostgreSQL (baza danych)
*   **Frontend:** Tailwind CSS, Hotwire (Turbo Frames, Turbo Streams, Stimulus)
*   **Infrastruktura:** Docker, Docker Compose

---

## ✨ Kluczowe Funkcjonalności

*   **Interaktywny panel boczny:** Trzykolumnowy układ z dynamicznie renderowanymi widgetami grup oraz znajomych.
*   **System grup:** Możliwość przypisywania postów do konkretnych grup (`belongs_to :group, optional: true`) oraz automatyczne kaskadowe usuwanie powiązanych danych (`dependent: :destroy` na poziomie modeli).
*   **Pełna konteneryzacja:** Środowisko deweloperskie zintegrowane w kontenerach zapewniających identyczne działanie niezależnie od systemu operacyjnego (Linux/Windows).

---

## 🐳 Konteneryzacja & Przenośność (Docker)

Aplikacja została w pełni przygotowana pod kątem uruchamiania na dowolnej maszynie.

---
