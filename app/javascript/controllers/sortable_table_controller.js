import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["header", "body"]

  connect() {
    this.currentColumn = null
    this.currentDirection = null

    // Add click listeners to sortable headers
    this.element.querySelectorAll('th.sortable').forEach(header => {
      header.addEventListener('click', () => {
        const column = header.dataset.column
        this.sort(column, header)
      })
    })
  }

  sort(column, headerElement) {
    const tbody = this.element.querySelector('tbody')
    const rows = Array.from(tbody.querySelectorAll('tr'))

    // Determine sort direction
    let direction = 'asc'
    if (this.currentColumn === column && this.currentDirection === 'asc') {
      direction = 'desc'
    }

    // Sort rows
    rows.sort((a, b) => {
      const aCell = a.querySelector(`td[data-value]:nth-child(${this.getColumnIndex(column)})`)
      const bCell = b.querySelector(`td[data-value]:nth-child(${this.getColumnIndex(column)})`)

      const aValue = parseFloat(aCell.dataset.value)
      const bValue = parseFloat(bCell.dataset.value)

      if (direction === 'asc') {
        return aValue - bValue
      } else {
        return bValue - aValue
      }
    })

    // Clear existing rows
    while (tbody.firstChild) {
      tbody.removeChild(tbody.firstChild)
    }

    // Add sorted rows
    rows.forEach(row => tbody.appendChild(row))

    // Update row styling (odd/even classes)
    this.updateRowStyling(rows)

    // Update sort indicators
    this.updateSortIndicators(column, direction, headerElement)

    // Update current sort state
    this.currentColumn = column
    this.currentDirection = direction
  }

  getColumnIndex(column) {
    const columnMap = {
      'number': 1,
      'participants': 3,
      'fastest_5k': 4,
      'fastest_2m': 5
    }
    return columnMap[column]
  }

  updateRowStyling(rows) {
    rows.forEach((row, index) => {
      row.classList.remove('odd:bg-white', 'even:bg-nw5k-eggplant-50')
      if (index % 2 === 0) {
        row.classList.add('bg-white')
      } else {
        row.classList.add('bg-nw5k-eggplant-50')
      }
    })
  }

  updateSortIndicators(column, direction, activeHeader) {
    // Clear all indicators
    this.element.querySelectorAll('th.sortable .sort-indicator').forEach(indicator => {
      indicator.textContent = ''
    })

    // Set the active indicator
    const indicator = activeHeader.querySelector('.sort-indicator')
    indicator.textContent = direction === 'asc' ? ' ▲' : ' ▼'
  }
}
