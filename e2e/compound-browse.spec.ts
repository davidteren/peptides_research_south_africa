import { test, expect } from "@playwright/test"

test("alias search shows the BPC-157 card", async ({ page }) => {
  await page.goto("/compounds")
  await page.locator("#compound-search-q").fill("BPC157")
  await page.locator("#compound-search-submit").click()
  await expect(page.locator("#compound-card-bpc-157")).toBeVisible()
})

test("unknown search shows no match and a report link", async ({ page }) => {
  await page.goto("/compounds")
  await page.locator("#compound-search-q").fill("xyzzy-not-a-peptide")
  await page.locator("#compound-search-submit").click()
  await expect(page.locator("#search-no-match")).toBeVisible()
  await expect(page.locator("#search-report-alias")).toBeVisible()
  await expect(page.locator("[data-testid=compound-card]")).toHaveCount(0)
})

test("injectable chip stays on the compounds index", async ({ page }) => {
  await page.goto("/compounds")
  await page.locator("#filter-route-injectable").click()
  await expect(page).toHaveURL(/\/compounds/)
  await expect(page.locator("#filter-route-injectable")).toHaveAttribute("aria-current", "true")
})
