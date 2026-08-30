import { test, expect } from "@playwright/test"

test("bpc-157 shows WADA, SAHPRA, SAIDS, and legal disclaimer by id", async ({ page }) => {
  await page.goto("/compounds/bpc-157")
  await expect(page.locator("#compound-wada")).toBeVisible()
  await expect(page.locator("#compound-wada-prohibited")).toBeVisible()
  await expect(page.locator("#compound-sahpra")).toBeVisible()
  await expect(page.locator("#compound-legal-disclaimer")).toBeVisible()
  await expect(page.locator("#compound-saids")).toBeVisible()
  await expect(page.locator("#catalog-disclaimer")).toBeVisible()
})
