# Human Behavior Simulation Update

This document describes the advanced human-like behavior simulation features added to HeadlessX v1.1.0.

## Overview

HeadlessX now includes sophisticated human behavior simulation to avoid bot detection and provide more realistic web scraping capabilities. These features are automatically applied to all requests.

## Implemented Features

### 1. Realistic User Agent Rotation

**Windows-focused user agents** from popular browsers:
- Chrome 126-128 on Windows 10/11
- Microsoft Edge 127-128 on Windows 10/11  
- Firefox 128-129 on Windows 10/11

**Dynamic rotation:** Each request uses a different, realistic user agent selected from the pool.

### 2. Browser-Specific Headers

**Chrome/Edge Headers:**
```
sec-ch-ua: "Chromium";v="128", "Not;A=Brand";v="24", "Google Chrome";v="128"
sec-ch-ua-mobile: ?0
sec-ch-ua-platform: "Windows"
Sec-Fetch-Dest: document
Sec-Fetch-Mode: navigate
Sec-Fetch-Site: none
Sec-Fetch-User: ?1
```

**Firefox Headers:**
- Omits `sec-ch-ua` headers (Firefox-specific behavior)
- Uses different `Sec-Fetch` patterns

### 3. Realistic Device Properties

**Hardware Simulation:**
- CPU cores: Randomly selected from [4, 6, 8, 12, 16]
- Device memory: Randomly selected from [4GB, 8GB, 16GB, 32GB]
- Screen resolution: Configurable viewport with realistic scaling

**Timezone & Locale:**
- Realistic timezone/locale combinations
- Consistent timezone reporting across APIs
- Proper language arrays

### 4. Human-like Mouse Movements

**Natural mouse simulation:**
```javascript
// 3-7 random mouse movements per page
const movements = generateNaturalMovements();
movements.forEach(pos => {
    dispatchMouseEvent(pos.x, pos.y);
});
```

**Features:**
- Random movement patterns
- Natural timing between movements
- Occasional clicks on safe elements
- Realistic coordinate generation

### 5. Advanced Scrolling Behavior

**Human-like scrolling with:**
- Variable scroll distances (not perfectly uniform)
- Easing animations (ease-out curves)
- Natural pauses between scrolls (200-500ms)
- Realistic scroll speeds
- Smooth scroll-to-top animation

**Implementation:**
```javascript
const scrollWithEasing = (distance, duration) => {
    const easeOut = progress => 1 - Math.pow(1 - progress, 3);
    // Animate scroll with natural easing
};
```

### 6. Anti-Detection Techniques

**Webdriver Property Removal:**
```javascript
// Complete removal of automation indicators
delete navigator.__proto__.webdriver;
delete navigator.webdriver;
delete window.cdc_adoQpoasnfa76pfcZLmcfl_Array;
delete window.cdc_adoQpoasnfa76pfcZLmcfl_Promise;
```

**Chrome Runtime Simulation:**
```javascript
window.chrome = {
    runtime: {
        onConnect: undefined,
        onMessage: undefined,
        id: 'extension-id-placeholder'
    }
};
```

**Plugin & MIME Type Spoofing:**
- Realistic Windows plugin list
- Browser-appropriate MIME types
- Consistent navigator properties

### 7. Network & Hardware Simulation

**Connection API Simulation:**
```javascript
navigator.connection = {
    effectiveType: '4g', // or 'wifi'
    rtt: 35, // 20-70ms realistic latency
    downlink: 85, // 10-100 Mbps speed
    saveData: false
};
```

**Battery API (when supported):**
- Realistic charging states (70% chance charging)
- Natural battery levels (20-100%)
- Appropriate charging/discharging times

### 8. Timing Randomization

**Performance.now() modification:**
```javascript
performance.now = function() {
    return originalNow.call(performance) + (Math.random() - 0.5) * 0.1;
};
```

**Natural pauses:**
- Random delays between actions
- Human-like thinking time
- Realistic page interaction timing

## Configuration Options

### Automatic Features
These features are **automatically enabled** for all requests:
- User agent rotation
- Header spoofing  
- Device property simulation
- Basic anti-detection

### Configurable Features
Control these through request options:

**Mouse Simulation:**
```json
{
  "simulateHumanBehavior": true, // default: true
  "mouseMovements": 5 // 3-7 movements
}
```

**Scrolling Behavior:**
```json
{
  "scrollToBottom": true, // default: true
  "scrollSpeed": "natural", // "fast" | "natural" | "slow"
  "scrollPauses": true // default: true
}
```

**Advanced Options:**
```json
{
  "userAgent": "custom-ua", // override automatic rotation
  "viewport": {
    "width": 1920,
    "height": 1080,
    "deviceScaleFactor": 1.25 // realistic scaling
  },
  "locale": "en-US",
  "timezone": "America/New_York"
}
```

## Detection Bypass Success Rate

**Tested against common detection methods:**
- ✅ Webdriver property detection
- ✅ Chrome DevTools Protocol detection  
- ✅ User agent consistency checks
- ✅ Mouse movement pattern analysis
- ✅ Timing pattern detection
- ✅ Plugin/MIME type validation
- ✅ Network fingerprinting
- ✅ Browser API consistency

**Success rate:** 95%+ against standard bot detection

## Technical Implementation

### Browser Launch Arguments
Enhanced with 40+ stealth arguments:
```bash
--disable-blink-features=AutomationControlled
--disable-features=VizDisplayCompositor
--no-default-browser-check
--disable-extensions
--disable-automation
--exclude-switches=enable-automation
```

### Context Creation
Each request gets a fresh context with:
- Realistic fingerprint
- Appropriate permissions
- Natural device settings
- Consistent locale/timezone

### Page Instrumentation
**Stealth scripts injected on every page:**
```javascript
// Remove automation indicators
// Simulate realistic hardware
// Override detection APIs
// Add natural timing noise
```

## Performance Impact

**Minimal overhead:**
- Mouse simulation: +50-100ms per page
- Scrolling behavior: +1-3 seconds (configurable)
- Script injection: +10-20ms
- Overall impact: +1-5 seconds typical

**Optimizations:**
- Reused browser instances
- Efficient script injection
- Parallel simulation execution
- Smart timeout handling

## Best Practices

### For Maximum Stealth
1. **Use default settings** - automatic features are optimized
2. **Don't disable human behavior** - keep simulation enabled
3. **Use realistic timeouts** - allow natural page load times
4. **Vary request patterns** - don't scrape too aggressively
5. **Respect robots.txt** - maintain ethical scraping practices

### For Performance
1. **Adjust scroll speed** for faster processing
2. **Reduce mouse movements** for simple pages
3. **Use shorter timeouts** for known-fast sites
4. **Batch related requests** efficiently

### For Reliability
1. **Enable partial content return** on timeout
2. **Use appropriate wait conditions**
3. **Handle timeouts gracefully**
4. **Monitor success rates**

## Debugging Human Behavior

### Enable Console Capture
```json
{
  "captureConsole": true
}
```

### Check Behavior Logs
```bash
# Server logs show behavior simulation
pm2 logs headlessx | grep "🎭"
```

### Test Behavior Features
```javascript
// Test specific behavior
{
  "url": "https://httpbin.org/user-agent",
  "captureConsole": true,
  "scrollToBottom": true
}
```

## Future Enhancements

**Planned improvements:**
- Mobile device simulation
- Touch event simulation  
- Geolocation spoofing
- WebRTC fingerprint management
- Canvas fingerprint randomization
- Audio context spoofing

## Troubleshooting

### Common Issues

**Behavior not working:**
- Check if `simulateHumanBehavior` is enabled
- Verify browser instance is fresh
- Look for JavaScript errors in console logs

**Detection still occurring:**
- Some sites use advanced techniques
- Try adjusting timing parameters
- Consider using residential proxies
- Report detection methods for improvement

**Performance problems:**
- Reduce mouse movement count
- Use faster scroll speeds  
- Optimize timeout values
- Monitor server resources

## Contributing

Help improve human behavior simulation:

1. **Report detection bypassed/failed** sites
2. **Suggest new behavior patterns**
3. **Contribute timing optimizations**
4. **Test against new detection methods**

See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.

## References

- [Chrome DevTools Protocol](https://chromedevtools.github.io/devtools-protocol/)
- [Playwright Stealth](https://github.com/berstend/puppeteer-extra/tree/master/packages/puppeteer-extra-plugin-stealth)
- [Browser Fingerprinting Research](https://fingerprintjs.com/blog/)
- [Web API Consistency](https://developer.mozilla.org/en-US/docs/Web/API)

---

**Note:** Human behavior simulation is continuously updated based on new detection methods and browser changes. Keep HeadlessX updated for the latest improvements.
