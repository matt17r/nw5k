import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

// Connects to data-controller="searchable-select"
export default class extends Controller {
  connect() {
    // Initialize Tom Select with mobile-friendly settings
    this.tomSelect = new TomSelect(this.element, {
      maxOptions: null, // Show all options
      allowEmptyOption: true,
      placeholder: 'Type to search...',
      hidePlaceholder: false,
      closeAfterSelect: true, // Close dropdown after selection (better for mobile)
      controlInput: '<input type="text" autocomplete="off" class="ts-input" />',
      render: {
        no_results: function(data, escape) {
          return '<div class="no-results">No results found for "' + escape(data.input) + '"</div>';
        }
      }
    })
  }

  disconnect() {
    if (this.tomSelect) {
      this.tomSelect.destroy()
    }
  }
}
