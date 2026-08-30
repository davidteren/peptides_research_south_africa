import { defineConfig } from "@playwright/test"
import path from "node:path"

const root = path.resolve(__dirname)

export default defineConfig({
  testDir: "./e2e",
  fullyParallel: false,
  use: {
    baseURL: "http://127.0.0.1:3001",
    trace: "on-first-retry"
  },
  webServer: {
    command:
      "bin/rails db:prepare && bin/rails catalog:import && bin/rails server -p 3001 -b 127.0.0.1",
    cwd: root,
    env: { ...process.env, RAILS_ENV: "test" },
    url: "http://127.0.0.1:3001",
    reuseExistingServer: !process.env.CI,
    timeout: 120000
  }
})
