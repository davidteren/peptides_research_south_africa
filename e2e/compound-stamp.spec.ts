import { test, expect } from "@playwright/test"

test("compound index shows the BPC-157 evidence stamp and citation", async ({ page }) => {
  await page.goto("/compounds")
  await expect(page.locator("#compound-stamp-bpc-157")).toBeVisible()
  await expect(page.locator("#compound-stamp-citation-bpc-157")).toBeVisible()
})
