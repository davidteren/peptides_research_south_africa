import { Controller } from "@hotwired/stimulus"

const STORAGE_KEY = "catalog.savedCompoundSlugs"
const SLUG = /^[a-z0-9]+(?:-[a-z0-9]+)*$/

export default class extends Controller {
  static values = {
    slug: String,
    saveLabel: String,
    unsaveLabel: String
  }
  static targets = [ "list", "empty" ]

  connect() {
    if (this.hasSlugValue) this.syncButton()
    if (this.hasListTarget) this.paintList()
  }

  toggle() {
    if (!this.hasSlugValue) return

    const slug = this.slugValue
    const slugs = this.read()
    const next = slugs.includes(slug) ? slugs.filter((value) => value !== slug) : slugs.concat(slug)
    this.write(next)
    this.syncButton()
  }

  syncButton() {
    const saved = this.read().includes(this.slugValue)
    this.element.setAttribute("aria-pressed", saved ? "true" : "false")
    const label = saved ? this.unsaveLabelValue : this.saveLabelValue
    if (label) this.element.textContent = label
  }

  paintList() {
    const slugs = this.read()
    if (this.hasEmptyTarget) this.emptyTarget.hidden = slugs.length > 0
    this.listTarget.hidden = slugs.length === 0
    this.listTarget.replaceChildren()

    slugs.forEach((slug) => {
      const item = document.createElement("li")
      item.id = `saved-item-${slug}`
      item.className = "py-3"
      const link = document.createElement("a")
      link.id = `saved-link-${slug}`
      link.href = `/compounds/${slug}`
      link.className = "underline"
      link.textContent = slug
      item.appendChild(link)
      this.listTarget.appendChild(item)
    })
  }

  read() {
    try {
      const parsed = JSON.parse(window.localStorage.getItem(STORAGE_KEY))
      if (!Array.isArray(parsed)) return []
      return parsed.map(String).filter((slug) => SLUG.test(slug))
    } catch (_error) {
      return []
    }
  }

  write(slugs) {
    window.localStorage.setItem(STORAGE_KEY, JSON.stringify(slugs))
  }
}
