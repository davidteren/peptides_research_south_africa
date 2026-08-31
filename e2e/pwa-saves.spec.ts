import { test, expect } from "@playwright/test"

test("manifest link is present and save survives reload", async ({ page }) => {
  await page.goto("/compounds/bpc-157")
  await expect(page.locator("#pwa-manifest")).toHaveCount(1)
  await expect(page.locator("#offline-stale-banner")).toBeHidden()

  await page.locator("#compound-save-bpc-157").click()
  await expect(page.locator("#compound-save-bpc-157")).toHaveAttribute("aria-pressed", "true")

  await page.reload()
  await expect(page.locator("#compound-save-bpc-157")).toHaveAttribute("aria-pressed", "true")

  await page.goto("/saved")
  await expect(page.locator("#saved-link-bpc-157")).toBeVisible()
  await expect(page.locator("#saved-index-empty")).toBeHidden()
})

test("offline visit shows the stale banner", async ({ page, context }) => {
  await page.goto("/compounds/bpc-157")
  await page.goto("/compounds")
  await context.setOffline(true)
  await page.locator("#compound-link-bpc-157").click()
  await expect(page.locator("#offline-stale-banner")).toBeVisible()
  await context.setOffline(false)
})

test("clearing storage empties saved and catalog still loads", async ({ page }) => {
  await page.goto("/compounds/bpc-157")
  await page.locator("#compound-save-bpc-157").click()
  await page.goto("/saved")
  await expect(page.locator("#saved-link-bpc-157")).toBeVisible()

  await page.evaluate(() => localStorage.clear())
  await page.goto("/saved")
  await expect(page.locator("#saved-index-empty")).toBeVisible()
  await expect(page.locator("#saved-link-bpc-157")).toHaveCount(0)

  await page.goto("/compounds")
  await expect(page.locator("#compound-index")).toBeVisible()
})
