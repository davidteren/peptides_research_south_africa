import { test, expect } from "@playwright/test"

test("checker shows pair notes and disclaimer for BPC-157 and TB-500", async ({ page }) => {
  await page.goto("/stacks/new")
  await page.locator("#stack-pick-bpc-157").check()
  await page.locator("#stack-pick-tb-500").check()
  await page.locator("#stack-picker-submit").click()
  await expect(page.locator("#stack-checker-notes")).toBeVisible()
  await expect(page.locator("#stack-pair-note-tb-500")).toBeVisible()
  await expect(page.locator("#catalog-disclaimer")).toBeVisible()
})

test("compound show has no pair-notes section", async ({ page }) => {
  await page.goto("/compounds/bpc-157")
  await expect(page.locator("#compound-pair-notes")).toHaveCount(0)
})
