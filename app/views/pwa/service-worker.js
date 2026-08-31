// Push stays off (#75). Do not add a live push or notificationclick listener.
// ponytail: cache catalog HTML plus runtime CSS/JS only. Do not cache product URLs.

const CACHE = "catalog-pages-v1"
const PRECACHE = [ "/", "/icon.png" ]

self.addEventListener("install", (event) => {
  event.waitUntil(
    caches.open(CACHE).then((cache) => cache.addAll(PRECACHE)).then(() => self.skipWaiting())
  )
})

self.addEventListener("activate", (event) => {
  event.waitUntil(self.clients.claim())
})

self.addEventListener("fetch", (event) => {
  const request = event.request
  if (request.method !== "GET") return
  if (request.headers.get("Content-Disposition")?.includes("attachment")) return

  const url = new URL(request.url)
  if (url.origin !== self.location.origin) return
  if (url.pathname === "/service-worker" || url.pathname.startsWith("/manifest")) return

  if (isCatalogHtml(request, url.pathname) || isRuntimeAsset(request)) {
    event.respondWith(networkFirst(request))
  }
})

function isCatalogPath(pathname) {
  return pathname === "/" ||
    pathname.startsWith("/compounds") ||
    pathname.startsWith("/providers") ||
    pathname.startsWith("/saved")
}

function isCatalogHtml(request, pathname) {
  const accept = request.headers.get("Accept") || ""
  const html = request.mode === "navigate" || accept.includes("text/html")
  return html && isCatalogPath(pathname)
}

function isRuntimeAsset(request) {
  return request.destination === "style" || request.destination === "script"
}

async function networkFirst(request) {
  try {
    const response = await fetch(request)
    if (response.ok) {
      const cache = await caches.open(CACHE)
      cache.put(request, response.clone())
    }
    return response
  } catch (error) {
    const cached = await caches.match(request)
    if (cached) return cached
    throw error
  }
}
