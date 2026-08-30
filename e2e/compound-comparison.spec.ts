import { test, expect } from "@playwright/test"

test("bpc-157 comparison table has form columns and no buy control", async ({ page }) => {
  await page.goto("/compounds/bpc-157")
  await expect(page.locator("#compound-comparison")).toBeVisible()
  await expect(page.locator("#listing-form-reschem-bpc-157-blend-nasal-10mg")).toBeVisible()
  await expect(page.locator("#listing-coa-reschem-bpc-157-blend-nasal-10mg")).toBeVisible()
  await expect(page.locator("[id^='buy-']")).toHaveCount(0)
})
