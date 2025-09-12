# 📤 HeadlessX POST Endpoints Documentation

Complete reference for all POST endpoints available in HeadlessX v1.1.0 - Advanced Browserless Web Scraping API.

---

## 📋 Table of Contents

1. [Full Page Rendering](#full-page-rendering)
2. [HTML Extraction](#html-extraction)
3. [Content Extraction](#content-extraction)
4. [Batch Processing](#batch-processing)
5. [Authentication](#authentication)
6. [Error Handling](#error-handling)
7. [Advanced Examples](#advanced-examples)

---

## 🎯 Full Page Rendering

### `POST /api/render`

Comprehensive page rendering with detailed JSON response including metadata, console logs, timing information, and human-like behavior simulation.

**URL Structure:**
```
POST https://headlessx.domain.com/render?token={TOKEN}
```

**Request Headers:**
```
Content-Type: application/json
```

**Request Body Parameters:**

**Required:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `url` | string | Target URL to render |

**Optional:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `waitUntil` | string | `networkidle` | Wait condition: `load`, `domcontentloaded`, `networkidle` |
| `timeout` | number | `60000` | Main timeout in milliseconds |
| `extraWaitTime` | number | `10000` | Additional wait for dynamic content |
| `userAgent` | string | Chrome default | Custom user agent string |
| `cookies` | array | `[]` | Array of cookie objects |
| `headers` | object | `{}` | Custom HTTP headers |
| `viewport` | object | `{width: 1920, height: 1080}` | Browser viewport size |
| `scrollToBottom` | boolean | `true` | Auto-scroll to trigger lazy loading |
| `waitForSelectors` | array | `[]` | CSS selectors to wait for |
| `clickSelectors` | array | `[]` | Elements to click during rendering |
| `removeElements` | array | `[]` | Elements to remove before extraction |
| `customScript` | string | `null` | Custom JavaScript to execute |
| `waitForNetworkIdle` | boolean | `true` | Wait for network idle state |
| `captureConsole` | boolean | `false` | Capture console logs |
| `returnPartialOnTimeout` | boolean | `true` | Return partial content on timeout |
| `fullPage` | boolean | `false` | Full page screenshot |
| `screenshotPath` | string | `null` | Path to save screenshot |
| `screenshotFormat` | string | `png` | Screenshot format: `png`, `jpeg` |
| `pdfPath` | string | `null` | Path to save PDF |
| `pdfFormat` | string | `A4` | PDF format |

**Response Format:**
```json
{
  "html": "<!DOCTYPE html><html>...</html>",
  "title": "Page Title",
  "url": "https://actual-final-url.com",
  "originalUrl": "https://requested-url.com",
  "consoleLogs": [
    {
      "type": "log",
      "text": "Console message",
      "location": {
        "url": "https://example.com/script.js",
        "lineNumber": 123
      }
    }
  ],
  "timestamp": "2025-09-11T14:30:25.123Z",
  "wasTimeout": false,
  "contentLength": 45678,
  "screenshotBuffer": null,
  "pdfBuffer": null
}
```

**Examples:**

**Basic Rendering:**
```bash
curl -X POST "https://headlessx.domain.com/render?token=SaifyXPRO@112255" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com"
  }'
```

**Advanced Rendering (Real Estate Example with HeadlessX):**
```bash
curl -X POST "https://headlessx.domain.com/render?token=SaifyXPRO@112255" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://www.mbl.is/fasteignir/fasteign/1524645",
    "timeout": 90000,
    "extraWaitTime": 10000,
    "waitUntil": "networkidle",
    "scrollToBottom": true,
    "waitForSelectors": [".property-details", ".images-loaded"],
    "removeElements": [".ads", ".social-widgets"],
    "captureConsole": true,
    "returnPartialOnTimeout": true
  }'
```

**E-commerce with Interactions:**
```bash
curl -X POST "https://playwright.saify.me/render?token=SaifyXPRO@112255" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://shop.example.com/product/123",
    "timeout": 75000,
    "extraWaitTime": 15000,
    "clickSelectors": [".load-reviews", ".show-more-images", ".size-guide"],
    "waitForSelectors": [".reviews-loaded", ".product-images"],
    "removeElements": [".popup", ".newsletter-signup"],
    "viewport": {
      "width": 1920,
      "height": 1080
    }
  }'
```

**SPA with Custom Script:**
```bash
curl -X POST "https://playwright.saify.me/render?token=SaifyXPRO@112255" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://spa-app.com/dashboard",
    "timeout": 120000,
    "extraWaitTime": 20000,
    "customScript": "localStorage.setItem(\"auth\", \"token123\"); window.dispatchEvent(new Event(\"dataload\"));",
    "waitForSelectors": [".dashboard-content", ".data-table"],
    "captureConsole": true
  }'
```

---

## 🌐 HTML Extraction

### `POST /api/html`

Extracts raw HTML content with advanced rendering options. Returns HTML directly (not JSON).

**URL Structure:**
```
POST https://playwright.saify.me/html?token={TOKEN}
```

**Request Headers:**
```
Content-Type: application/json
```

**Request Body:** Same parameters as `/render` endpoint

**Response Headers:**
```
Content-Type: text/html; charset=utf-8
X-Rendered-URL: {actual_url}
X-Page-Title: {page_title}
X-Timestamp: {timestamp}
X-Was-Timeout: {true/false}
X-Content-Length: {content_length}
X-Is-Emergency: {true/false}
```

**Response:** Raw HTML content

**Examples:**

**Basic HTML Extraction:**
```bash
curl -X POST "https://playwright.saify.me/html?token=SaifyXPRO@112255" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com"
  }' --output page.html
```

**Real Estate Page with Extended Timing:**
```bash
curl -X POST "https://playwright.saify.me/html?token=SaifyXPRO@112255" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://www.mbl.is/fasteignir/fasteign/1524645",
    "timeout": 90000,
    "extraWaitTime": 10000,
    "scrollToBottom": true,
    "waitForSelectors": [".property-info", ".image-gallery"],
    "removeElements": [".advertisement", ".cookie-banner"]
  }' --output property.html
```

**News Article Extraction:**
```bash
curl -X POST "https://playwright.saify.me/html?token=SaifyXPRO@112255" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://news-site.com/breaking-news",
    "timeout": 60000,
    "waitForSelectors": [".article-content", ".article-meta"],
    "removeElements": [".sidebar", ".related-articles", ".social-share", ".ads"],
    "scrollToBottom": false
  }'
```

**Complex SPA:**
```bash
curl -X POST "https://playwright.saify.me/html?token=SaifyXPRO@112255" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://complex-spa.com/data",
    "timeout": 120000,
    "extraWaitTime": 25000,
    "waitUntil": "networkidle",
    "waitForSelectors": [".data-loaded", ".charts-rendered"],
    "clickSelectors": [".load-data", ".expand-charts"],
    "customScript": "window.loadAllData(); setTimeout(() => window.renderCharts(), 5000);"
  }'
```

---

## 📄 Content Extraction

### `POST /api/content`

Extracts clean, readable text content from web pages, automatically removing navigation, ads, and other non-content elements.

**URL Structure:**
```
POST https://playwright.saify.me/content?token={TOKEN}
```

**Request Headers:**
```
Content-Type: application/json
```

**Request Body:** Same parameters as `/render` endpoint

**Response Headers:**
```
Content-Type: text/plain; charset=utf-8
X-Rendered-URL: {actual_url}
X-Page-Title: {page_title}
X-Content-Length: {text_length}
X-Timestamp: {timestamp}
X-Was-Timeout: {true/false}
X-Is-Emergency: {true/false}
```

**Response:** Clean text content only

**Examples:**

**Article Content Extraction:**
```bash
curl -X POST "https://playwright.saify.me/content?token=SaifyXPRO@112255" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://blog.example.com/article-title",
    "timeout": 45000,
    "waitForSelectors": [".article-body", ".article-title"],
    "removeElements": [".author-bio", ".related-posts", ".comments"]
  }' --output article.txt
```

**Real Estate Description:**
```bash
curl -X POST "https://playwright.saify.me/content?token=SaifyXPRO@112255" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://www.mbl.is/fasteignir/fasteign/1524645",
    "timeout": 75000,
    "extraWaitTime": 10000,
    "waitForSelectors": [".property-description", ".property-details"],
    "removeElements": [".contact-form", ".similar-properties", ".ads"]
  }'
```

**Product Description:**
```bash
curl -X POST "https://playwright.saify.me/content?token=SaifyXPRO@112255" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://store.com/products/item-123",
    "waitForSelectors": [".product-description", ".specifications"],
    "clickSelectors": [".read-more", ".show-specs"],
    "removeElements": [".price", ".add-to-cart", ".reviews-section"]
  }'
```

---

## 🔄 Batch Processing

### `POST /api/batch`

Process multiple URLs simultaneously with controlled concurrency for efficient bulk operations.

**URL Structure:**
```
POST https://playwright.saify.me/batch?token={TOKEN}
```

**Request Headers:**
```
Content-Type: application/json
```

**Request Body Parameters:**

**Required:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `urls` | array | Array of URLs to process (max 10) |

**Optional:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `concurrency` | number | `3` | Number of parallel requests |
| All other parameters from `/render` endpoint | | | Applied to all URLs |

**Response Format:**
```json
{
  "totalUrls": 5,
  "successful": 4,
  "failed": 1,
  "results": [
    {
      "url": "https://example1.com",
      "success": true,
      "result": {
        "html": "...",
        "title": "Page 1",
        "timestamp": "2025-09-11T14:30:25.123Z",
        "wasTimeout": false
      }
    }
  ],
  "errors": [
    {
      "url": "https://failed-site.com",
      "success": false,
      "error": "Navigation timeout"
    }
  ],
  "timestamp": "2025-09-11T14:30:25.123Z"
}
```

**Examples:**

**Basic Batch Processing:**
```bash
curl -X POST "https://playwright.saify.me/batch?token=SaifyXPRO@112255" \
  -H "Content-Type: application/json" \
  -d '{
    "urls": [
      "https://example1.com",
      "https://example2.com", 
      "https://example3.com"
    ],
    "concurrency": 2,
    "timeout": 60000
  }'
```

**Real Estate Listings Batch:**
```bash
curl -X POST "https://playwright.saify.me/batch?token=SaifyXPRO@112255" \
  -H "Content-Type: application/json" \
  -d '{
    "urls": [
      "https://www.mbl.is/fasteignir/fasteign/1524645",
      "https://www.mbl.is/fasteignir/fasteign/1524646",
      "https://www.mbl.is/fasteignir/fasteign/1524647",
      "https://www.mbl.is/fasteignir/fasteign/1524648"
    ],
    "concurrency": 2,
    "timeout": 90000,
    "extraWaitTime": 10000,
    "scrollToBottom": true,
    "waitForSelectors": [".property-details"],
    "removeElements": [".ads", ".similar-properties"]
  }'
```

**E-commerce Product Pages:**
```bash
curl -X POST "https://playwright.saify.me/batch?token=SaifyXPRO@112255" \
  -H "Content-Type: application/json" \
  -d '{
    "urls": [
      "https://shop.com/product/1",
      "https://shop.com/product/2",
      "https://shop.com/product/3",
      "https://shop.com/product/4",
      "https://shop.com/product/5"
    ],
    "concurrency": 3,
    "timeout": 75000,
    "clickSelectors": [".load-reviews"],
    "waitForSelectors": [".product-details", ".customer-reviews"],
    "removeElements": [".recommendations", ".recently-viewed"]
  }'
```

**News Articles Batch:**
```bash
curl -X POST "https://playwright.saify.me/batch?token=SaifyXPRO@112255" \
  -H "Content-Type: application/json" \
  -d '{
    "urls": [
      "https://news.com/article-1",
      "https://news.com/article-2",
      "https://news.com/article-3"
    ],
    "concurrency": 3,
    "timeout": 45000,
    "waitForSelectors": [".article-content"],
    "removeElements": [".sidebar", ".social-share", ".ads", ".comments"]
  }'
```

---

## 🔐 Authentication

All POST endpoints require authentication via one of these methods:

**Method 1: Query Parameter (Recommended)**
```bash
POST https://playwright.saify.me/render?token=SaifyXPRO@112255
```

**Method 2: Header (X-Token)**
```bash
curl -X POST "https://playwright.saify.me/render" \
  -H "X-Token: SaifyXPRO@112255" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com"}'
```

**Method 3: Header (Authorization Bearer)**
```bash
curl -X POST "https://playwright.saify.me/render" \
  -H "Authorization: Bearer SaifyXPRO@112255" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com"}'
```

---

## ❌ Error Handling

**HTTP Status Codes:**

| Code | Description | Response Format |
|------|-------------|-----------------|
| `200` | Success | JSON or content |
| `400` | Bad Request | JSON error object |
| `401` | Unauthorized | JSON error object |
| `500` | Server Error | JSON error object |

**Error Response Format:**
```json
{
  "error": "Failed to render page",
  "details": "Navigation timeout exceeded",
  "timestamp": "2025-09-11T14:30:25.123Z"
}
```

**Common Errors:**

**Missing URL:**
```json
{
  "error": "Missing required field: url"
}
```

**Invalid URL:**
```json
{
  "error": "Invalid URL format"
}
```

**Authentication Error:**
```json
{
  "error": "Unauthorized: Invalid token"
}
```

**Timeout Error with Partial Content:**
```json
{
  "html": "<!DOCTYPE html>...",
  "title": "Partial Page",
  "wasTimeout": true,
  "isEmergencyContent": true,
  "timestamp": "2025-09-11T14:30:25.123Z"
}
```

---

## 🎯 Advanced Examples

### Example 1: Complex Real Estate Site
```bash
curl -X POST "https://playwright.saify.me/render?token=SaifyXPRO@112255" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://www.mbl.is/fasteignir/fasteign/1524645",
    "timeout": 120000,
    "extraWaitTime": 15000,
    "waitUntil": "networkidle",
    "scrollToBottom": true,
    "waitForSelectors": [
      ".property-details",
      ".image-gallery",
      ".property-description",
      ".location-map"
    ],
    "clickSelectors": [
      ".load-more-images",
      ".show-full-description",
      ".load-similar-properties"
    ],
    "removeElements": [
      ".advertisement",
      ".cookie-banner",
      ".social-widgets",
      ".newsletter-signup"
    ],
    "captureConsole": true,
    "returnPartialOnTimeout": true,
    "viewport": {
      "width": 1920,
      "height": 1080
    }
  }'
```

### Example 2: E-commerce with Authentication
```bash
curl -X POST "https://playwright.saify.me/html?token=SaifyXPRO@112255" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://secure-shop.com/account/orders",
    "timeout": 90000,
    "cookies": [
      {
        "name": "session_id",
        "value": "abc123xyz789",
        "domain": "secure-shop.com",
        "path": "/"
      },
      {
        "name": "auth_token",
        "value": "user_token_here",
        "domain": "secure-shop.com",
        "path": "/"
      }
    ],
    "headers": {
      "X-API-Key": "your-api-key"
    },
    "waitForSelectors": [".order-history", ".account-details"],
    "customScript": "document.querySelector(\".load-more-orders\")?.click();"
  }'
```

### Example 3: SPA Dashboard
```bash
curl -X POST "https://playwright.saify.me/content?token=SaifyXPRO@112255" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://analytics-dashboard.com/reports",
    "timeout": 180000,
    "extraWaitTime": 30000,
    "waitUntil": "networkidle",
    "customScript": "localStorage.setItem(\"user_id\", \"12345\"); window.loadDashboard(); setTimeout(() => { window.generateReport(\"monthly\"); }, 10000);",
    "waitForSelectors": [
      ".dashboard-loaded",
      ".charts-rendered", 
      ".data-table-complete"
    ],
    "clickSelectors": [
      ".accept-cookies",
      ".load-monthly-data",
      ".expand-all-charts"
    ],
    "removeElements": [
      ".help-widget",
      ".feedback-button",
      ".upgrade-banner"
    ]
  }'
```

### Example 4: News Site with Multiple Interactions
```bash
curl -X POST "https://playwright.saify.me/render?token=SaifyXPRO@112255" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://news-site.com/live-updates",
    "timeout": 150000,
    "extraWaitTime": 20000,
    "scrollToBottom": true,
    "waitForSelectors": [
      ".live-updates-loaded",
      ".article-content",
      ".comments-loaded"
    ],
    "clickSelectors": [
      ".load-more-updates",
      ".show-all-comments",
      ".expand-related-articles"
    ],
    "removeElements": [
      ".advertisement",
      ".social-media-widgets",
      ".newsletter-popup",
      ".video-ads"
    ],
    "captureConsole": true,
    "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
  }'
```

### Example 5: Batch Processing Real Estate Listings
```bash
curl -X POST "https://playwright.saify.me/batch?token=SaifyXPRO@112255" \
  -H "Content-Type: application/json" \
  -d '{
    "urls": [
      "https://www.mbl.is/fasteignir/fasteign/1524645",
      "https://www.mbl.is/fasteignir/fasteign/1524646",
      "https://www.mbl.is/fasteignir/fasteign/1524647",
      "https://www.mbl.is/fasteignir/fasteign/1524648",
      "https://www.mbl.is/fasteignir/fasteign/1524649"
    ],
    "concurrency": 2,
    "timeout": 90000,
    "extraWaitTime": 12000,
    "scrollToBottom": true,
    "waitUntil": "networkidle",
    "waitForSelectors": [
      ".property-details",
      ".image-gallery"
    ],
    "removeElements": [
      ".advertisement",
      ".similar-properties-widget",
      ".social-share"
    ],
    "returnPartialOnTimeout": true
  }'
```

---

## ⏱️ Timing Guidelines

**Recommended Settings by Site Complexity:**

| Site Type | Timeout | Extra Wait | Concurrency (Batch) |
|-----------|---------|------------|---------------------|
| Static HTML | 30s | 5s | 5 |
| News Sites | 45s | 10s | 4 |
| E-commerce | 75s | 15s | 3 |
| Real Estate | 90s | 12s | 2 |
| SPAs | 120s | 25s | 2 |
| Complex Dashboards | 180s | 30s | 1 |

**Your Use Case (Real Estate):**
- **Timeout**: 90,000ms (90 seconds)
- **Extra Wait**: 10,000-15,000ms
- **Wait Until**: `networkidle`
- **Scroll**: `true`
- **Batch Concurrency**: 2

---

## 🔄 Rate Limiting

**Current Limits:**
- **30 requests per minute** per IP
- **Burst capacity**: 50 requests
- **Batch processing**: Counts as 1 request regardless of URL count

**Headers in Response:**
```
X-RateLimit-Limit: 30
X-RateLimit-Remaining: 25
X-RateLimit-Reset: 1694441425
```

---

## 💡 Best Practices

1. **Use appropriate timeouts** based on site complexity
2. **Enable `returnPartialOnTimeout`** for unreliable sites
3. **Remove unnecessary elements** to reduce response size
4. **Use specific selectors** for critical content
5. **Batch similar sites** for efficiency
6. **Monitor response headers** for timeout indicators
7. **Handle partial content** gracefully in your application
8. **Use proper error handling** for failed requests

---

## 🎯 Make.com Integration Examples

### Option 1: JSON Response (Full Control)
```
Method: POST
URL: https://headlessx.domain.com/render?token=SaifyXPRO@112255
Headers: Content-Type: application/json
Body: {
  "url": "{{dynamic_url}}",
  "timeout": 90000,
  "extraWaitTime": 10000,
  "scrollToBottom": true
}
```

### Option 2: Raw HTML (Simplest)
```
Method: POST  
URL: https://headlessx.domain.com/html?token=SaifyXPRO@112255
Headers: Content-Type: application/json
Body: {
  "url": "{{dynamic_url}}",
  "timeout": 75000
}
```

### Option 3: Clean Text Only
```
Method: POST
URL: https://headlessx.domain.com/content?token=SaifyXPRO@112255  
Headers: Content-Type: application/json
Body: {
  "url": "{{dynamic_url}}",
  "removeElements": [".ads", ".navigation"]
}
```

---

*Last updated: September 12, 2025*
*HeadlessX v1.1.0 - Advanced Browserless Web Scraping API*
