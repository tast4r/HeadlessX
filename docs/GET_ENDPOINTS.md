# 🌐 HeadlessX GET Endpoints Documentation

Complete reference for all GET endpoints available in HeadlessX v1.1.0 - Advanced Browserless Web Scraping API.

---

## 📋 Table of Contents

1. [Health Check](#health-check)
2. [Server Status](#server-status)
3. [HTML Extraction](#html-extraction)
4. [Content Extraction](#content-extraction)
5. [Screenshot Capture](#screenshot-capture)
6. [PDF Generation](#pdf-generation)
7. [Authentication](#authentication)
8. [Error Handling](#error-handling)
9. [Examples](#examples)

---

## 🔍 Health Check

### `GET /api/health`

Returns HeadlessX server health status with detailed system information.

**URL Structure:**
```
GET https://headlessx.domain.com/api/health
```

**Parameters:** None required

**Response Example:**
```json
{
  "status": "OK",
  "timestamp": "2025-09-12T14:30:25.123Z",
  "browserConnected": true,
  "uptime": "2h 30m 45s",
  "memory": {
    "rss": "245MB",
    "heapTotal": "180MB",
    "heapUsed": "120MB",
    "external": "50MB"
  },
  "version": "1.1.0",
  "features": [
    "Advanced timeout handling",
    "Partial content recovery",
    "Emergency extraction",
    "Screenshot capture",
    "PDF generation",
    "Batch processing",
    "Clean text extraction",
    "Realistic user agent rotation",
    "Human-like behavior simulation",
    "Advanced stealth techniques"
  ]
}
```

**cURL Example:**
```bash
curl -X GET "https://headlessx.domain.com/health"
```

---

## 📊 Server Status

### `GET /api/status`

Returns detailed HeadlessX server information including available endpoints and system metrics.

**URL Structure:**
```
GET https://headlessx.domain.com/api/status
```

**Parameters:** None required

**Response Example:**
```json
{
  "server": {
    "name": "HeadlessX - Advanced Browserless API",
    "version": "1.1.0",
    "uptime": 9045,
    "startTime": "2025-09-12T12:00:00.000Z"
  },
  "browser": {
    "connected": true,
    "type": "Chromium"
  },
  "endpoints": [
    "GET /api/health - Server health check",
    "GET /api/status - Detailed server status",
    "POST /api/render - Full page rendering with JSON response",
    "POST /api/html - Raw HTML extraction",
    "GET /api/html - Raw HTML extraction (GET)",
    "POST /api/content - Clean text extraction",
    "GET /api/content - Clean text extraction (GET)",
    "GET /api/screenshot - Screenshot generation",
    "GET /api/pdf - PDF generation",
    "POST /api/batch - Batch URL processing"
  ],
  "memory": {
    "rss": 257425408,
    "heapTotal": 188743680,
    "heapUsed": 125829344,
    "external": 52428800
  },
  "timestamp": "2025-09-12T14:30:25.123Z"
}
```

**cURL Example:**
```bash
curl -X GET "https://headlessx.domain.com/status"
```

---

## 🌐 HTML Extraction

### `GET /api/html`

Extracts raw HTML content from any website with JavaScript rendering support and human-like behavior.

**URL Structure:**
```
GET https://headlessx.domain.com/html?token={TOKEN}&url={URL}&[OPTIONAL_PARAMS]
```

**Required Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `token` | string | Authentication token |
| `url` | string | Target URL to render (URL encoded) |

**Optional Parameters:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `waitUntil` | string | `networkidle` | Wait condition: `load`, `domcontentloaded`, `networkidle` |
| `timeout` | number | `60000` | Main timeout in milliseconds |
| `extraWait` | number | `10000` | Extra wait time for dynamic content |
| `scroll` | boolean | `true` | Auto-scroll to trigger lazy loading |
| `networkIdle` | boolean | `true` | Wait for network idle state |
| `console` | boolean | `false` | Capture console logs |
| `returnPartial` | boolean | `true` | Return partial content on timeout |
| `waitForSelectors` | string | - | Comma-separated CSS selectors to wait for |
| `clickSelectors` | string | - | Comma-separated selectors to click |
| `removeElements` | string | - | Comma-separated selectors to remove |

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

**Basic Usage:**
```bash
curl -X GET "https://headlessx.domain.com/html?token=SaifyXPRO@112255&url=https://example.com"
```

**Advanced Usage (real estate example):**
```bash
curl -X GET "https://headlessx.domain.com/html?token=SaifyXPRO@112255&url=https://www.mbl.is/fasteignir/fasteign/1524645&extraWait=10000"
```

**With Multiple Options:**
```bash
curl -X GET "https://headlessx.domain.com/html?token=SaifyXPRO@112255&url=https://spa-site.com&timeout=90000&extraWait=15000&scroll=true&waitUntil=networkidle&waitForSelectors=.content,.main&removeElements=.ads,.popup"
```

**URL Encoding Example:**
```bash
# For URLs with special characters, use URL encoding
# Original: https://example.com/search?q=test query&lang=en
# Encoded: https%3A%2F%2Fexample.com%2Fsearch%3Fq%3Dtest%2520query%26lang%3Den

curl -X GET "https://headlessx.domain.com/html?token=SaifyXPRO@112255&url=https%3A%2F%2Fexample.com%2Fsearch%3Fq%3Dtest%2520query%26lang%3Den"
```

---

## 📄 Content Extraction

### `GET /api/content`

Extracts clean, readable text content from any website, removing ads, navigation, and other non-content elements using HeadlessX's intelligent parsing.

**URL Structure:**
```
GET https://headlessx.domain.com/content?token={TOKEN}&url={URL}&[OPTIONAL_PARAMS]
```

**Parameters:** Same as HTML extraction endpoint

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

**Basic Usage:**
```bash
curl -X GET "https://playwright.saify.me/content?token=SaifyXPRO@112255&url=https://news-site.com/article"
```

**With Extended Timeout:**
```bash
curl -X GET "https://playwright.saify.me/content?token=SaifyXPRO@112255&url=https://slow-loading-site.com&timeout=120000&extraWait=20000"
```

**News Article Extraction:**
```bash
curl -X GET "https://playwright.saify.me/content?token=SaifyXPRO@112255&url=https://www.mbl.is/fasteignir/fasteign/1524645&removeElements=.ads,.social,.comments&waitForSelectors=.article-content"
```

---

## 📸 Screenshot Capture

### `GET /api/screenshot`

Captures screenshots of rendered web pages in PNG or JPEG format.

**URL Structure:**
```
GET https://playwright.saify.me/screenshot?token={TOKEN}&url={URL}&[OPTIONAL_PARAMS]
```

**Required Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `token` | string | Authentication token |
| `url` | string | Target URL to capture |

**Optional Parameters:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `fullPage` | boolean | `false` | Capture full page or viewport only |
| `format` | string | `png` | Image format: `png` or `jpeg` |
| `width` | number | `1920` | Viewport width in pixels |
| `height` | number | `1080` | Viewport height in pixels |
| `timeout` | number | `30000` | Rendering timeout |
| `returnPartial` | boolean | `true` | Return partial content on timeout |

**Response Headers:**
```
Content-Type: image/png (or image/jpeg)
X-Rendered-URL: {actual_url}
X-Page-Title: {page_title}
X-Timestamp: {timestamp}
X-Was-Timeout: {true/false}
Content-Disposition: inline; filename="screenshot-{timestamp}.{format}"
```

**Response:** Binary image data

**Examples:**

**Basic Screenshot:**
```bash
curl -X GET "https://playwright.saify.me/screenshot?token=SaifyXPRO@112255&url=https://example.com" --output screenshot.png
```

**Full Page Screenshot:**
```bash
curl -X GET "https://playwright.saify.me/screenshot?token=SaifyXPRO@112255&url=https://long-page.com&fullPage=true" --output fullpage.png
```

**High Resolution JPEG:**
```bash
curl -X GET "https://playwright.saify.me/screenshot?token=SaifyXPRO@112255&url=https://example.com&format=jpeg&width=2560&height=1440" --output hires.jpg
```

**Mobile Viewport:**
```bash
curl -X GET "https://playwright.saify.me/screenshot?token=SaifyXPRO@112255&url=https://mobile-site.com&width=375&height=667" --output mobile.png
```

---

## 📑 PDF Generation

### `GET /api/pdf`

Generates PDF documents from rendered web pages with customizable formatting options.

**URL Structure:**
```
GET https://playwright.saify.me/pdf?token={TOKEN}&url={URL}&[OPTIONAL_PARAMS]
```

**Required Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `token` | string | Authentication token |
| `url` | string | Target URL to convert |

**Optional Parameters:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `format` | string | `A4` | Paper format: `A4`, `A3`, `Letter`, `Legal` |
| `background` | boolean | `true` | Include background graphics |
| `marginTop` | string | `20px` | Top margin |
| `marginRight` | string | `20px` | Right margin |
| `marginBottom` | string | `20px` | Bottom margin |
| `marginLeft` | string | `20px` | Left margin |
| `timeout` | number | `30000` | Rendering timeout |
| `returnPartial` | boolean | `true` | Return partial content on timeout |

**Response Headers:**
```
Content-Type: application/pdf
X-Rendered-URL: {actual_url}
X-Page-Title: {page_title}
X-Timestamp: {timestamp}
X-Was-Timeout: {true/false}
Content-Disposition: inline; filename="page-{timestamp}.pdf"
```

**Response:** Binary PDF data

**Examples:**

**Basic PDF:**
```bash
curl -X GET "https://playwright.saify.me/pdf?token=SaifyXPRO@112255&url=https://example.com" --output document.pdf
```

**Custom Format and Margins:**
```bash
curl -X GET "https://playwright.saify.me/pdf?token=SaifyXPRO@112255&url=https://article.com&format=Letter&marginTop=30px&marginLeft=30px&marginRight=30px&marginBottom=30px" --output article.pdf
```

**No Background (Text Only):**
```bash
curl -X GET "https://playwright.saify.me/pdf?token=SaifyXPRO@112255&url=https://text-content.com&background=false" --output text-only.pdf
```

---

## 🔐 Authentication

All GET endpoints require authentication via the `token` query parameter.

**Token Methods:**
- **Query Parameter**: `?token=YOUR_TOKEN` (recommended for GET requests)
- **Header**: `X-Token: YOUR_TOKEN`
- **Header**: `Authorization: Bearer YOUR_TOKEN`

**Example with Header Authentication:**
```bash
curl -X GET "https://playwright.saify.me/html?url=https://example.com" \
  -H "X-Token: SaifyXPRO@112255"
```

---

## ❌ Error Handling

**Common HTTP Status Codes:**

| Code | Description |
|------|-------------|
| `200` | Success |
| `400` | Bad Request - Invalid URL or parameters |
| `401` | Unauthorized - Invalid or missing token |
| `404` | Endpoint not found |
| `500` | Internal Server Error - Rendering failed |

**Error Response Format:**
```
HTTP/1.1 400 Bad Request
Content-Type: text/plain

Error: Invalid URL format
```

**Timeout Handling:**
- When `returnPartial=true` (default), partial content is returned even on timeouts
- Response headers include `X-Was-Timeout: true` to indicate timeout occurred
- Emergency extraction may be attempted for difficult sites

---

## 📚 Complete Examples

### Example 1: Real Estate Page (Your Use Case)
```bash
# Extract HTML from Icelandic real estate site with extended wait time
curl -X GET "https://playwright.saify.me/html?token=SaifyXPRO@112255&url=https://www.mbl.is/fasteignir/fasteign/1524645&extraWait=10000&timeout=90000&scroll=true" --output property.html

# Get clean text content only
curl -X GET "https://playwright.saify.me/content?token=SaifyXPRO@112255&url=https://www.mbl.is/fasteignir/fasteign/1524645&extraWait=10000" --output property.txt

# Capture screenshot
curl -X GET "https://playwright.saify.me/screenshot?token=SaifyXPRO@112255&url=https://www.mbl.is/fasteignir/fasteign/1524645&fullPage=true" --output property.png
```

### Example 2: E-commerce Product Page
```bash
# Handle dynamic loading with selectors
curl -X GET "https://playwright.saify.me/html?token=SaifyXPRO@112255&url=https://shop.com/product/123&waitForSelectors=.product-details,.reviews&clickSelectors=.load-reviews&removeElements=.ads,.popup&timeout=60000"
```

### Example 3: News Article with Clean Text
```bash
# Extract article content without navigation/ads
curl -X GET "https://playwright.saify.me/content?token=SaifyXPRO@112255&url=https://news-site.com/breaking-news&removeElements=.sidebar,.comments,.social-share,.ads"
```

### Example 4: SPA Application
```bash
# Handle Single Page Application with extended timeouts
curl -X GET "https://playwright.saify.me/html?token=SaifyXPRO@112255&url=https://spa-app.com/dashboard&waitUntil=networkidle&timeout=120000&extraWait=20000&waitForSelectors=.dashboard-content,.data-loaded"
```

### Example 5: Mobile Screenshot
```bash
# Capture mobile view screenshot
curl -X GET "https://playwright.saify.me/screenshot?token=SaifyXPRO@112255&url=https://mobile-first-site.com&width=375&height=812&fullPage=true" --output mobile-view.png
```

---

## ⏱️ Timing Recommendations

**Timeout Settings by Site Type:**

| Site Type | Timeout | Extra Wait | Notes |
|-----------|---------|------------|-------|
| Static Sites | 30000ms | 5000ms | Basic HTML/CSS |
| News Sites | 45000ms | 10000ms | Images, ads loading |
| E-commerce | 60000ms | 15000ms | Product images, reviews |
| SPAs | 90000ms | 20000ms | JavaScript heavy |
| Complex Apps | 120000ms | 30000ms | Multiple API calls |

**Your Real Estate Example Timing:**
```bash
# Optimized for property listing sites
&timeout=75000&extraWait=10000&waitUntil=networkidle
```

---

## 🔄 Rate Limiting

Current rate limits (if configured):
- **30 requests per minute** per IP address
- **Burst capacity**: 50 requests
- **Headers included**: `X-RateLimit-*` headers in responses

---

## 🎯 Best Practices

1. **Always URL encode** your target URLs
2. **Use appropriate timeouts** based on site complexity
3. **Enable returnPartial** for unreliable sites
4. **Remove unwanted elements** to reduce payload size
5. **Use specific selectors** to wait for critical content
6. **Monitor response headers** for timeout indicators
7. **Handle errors gracefully** in your applications

---

*Last updated: September 12, 2025*
*HeadlessX v1.1.0 - Advanced Browserless Web Scraping API*
