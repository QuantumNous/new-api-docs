# Analytics Tool Setup Guide

### Overview

New API now supports integration with popular analytics platforms to help you track user behavior and website performance:

- **Google Analytics 4 (GA4)**: The latest version of Google's analytics platform
- **Umami Analytics**: A privacy-focused, open-source analytics tool

Both analytics tools can be enabled simultaneously without conflict.

### Key Features

✅ Zero-code integration - configured solely via environment variables  
✅ Automatically injects scripts into the Web interface  
✅ Supports Docker and Standalone deployment  
✅ Privacy-focused implementation  
✅ No front-end code modification required  

---

### Google Analytics 4 Setup

#### 1. Obtain Your Measurement ID

1. Visit [Google Analytics](https://analytics.google.com/)
2. Create a new property or select an existing one
3. Go to **Admin** → **Data Streams**
4. Create or select a web data stream
5. Copy your **Measurement ID** (Format: `G-XXXXXXXXXX`)

#### 2. Configure Environment Variables

**Using Docker Compose:**

Edit the `docker-compose.yml` file and uncomment the Google Analytics line:

```yaml
environment:
  - GOOGLE_ANALYTICS_ID=G-XXXXXXXXXX  # Replace with your actual Measurement ID
```

**Standalone Deployment:**

Add to the `.env` file or set as an environment variable:

```bash
export GOOGLE_ANALYTICS_ID=G-XXXXXXXXXX
```

**Using Docker Run:**

```bash
docker run -d \
  -e GOOGLE_ANALYTICS_ID=G-XXXXXXXXXX \
  ...其他选项...
  calciumion/new-api:latest
```

#### 3. Restart the Application

```bash
# Docker Compose
docker-compose down && docker-compose up -d

# Standalone Deployment
# Restart your application directly
```

---

### Umami Analytics Setup

#### 1. Obtain Umami Credentials

**Option A: Using Umami Cloud**
1. Register on [Umami Cloud](https://cloud.umami.is/)
2. Add a new website
3. Copy your **Website ID** (UUID format)

**Option B: Self-hosting Umami**
1. Deploy your own [Umami instance](https://umami.is/docs/install)
2. Create a website in the dashboard
3. Copy your **Website ID** and **Script URL**

#### 2. Configure Environment Variables

**Using Docker Compose:**

Edit the `docker-compose.yml` file:

```yaml
environment:
  - UMAMI_WEBSITE_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
  # Optional: Only required for self-hosted instances
  - UMAMI_SCRIPT_URL=https://your-umami-domain.com/script.js
```

**Standalone Deployment:**

Add to the `.env` file:

```bash
export UMAMI_WEBSITE_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
export UMAMI_SCRIPT_URL=https://your-umami-domain.com/script.js  # Optional
```

**Note:** If using Umami Cloud, you do not need to set `UMAMI_SCRIPT_URL`, as it defaults to the official URL.

#### 3. Restart the Application

Same as Google Analytics - restart the application to apply changes.

---

### Using Both Analytics Tools Simultaneously

You can enable both Google Analytics and Umami at the same time:

```yaml
environment:
  - GOOGLE_ANALYTICS_ID=G-ABC123XYZ
  - UMAMI_WEBSITE_ID=a1b2c3d4-e5f6-g7h8-i9j0-k1l2m3n4o5p6
  - UMAMI_SCRIPT_URL=https://analytics.umami.is/script.js
```

---

### Verification

After restarting the application:

1. Open the Web interface in your browser
2. Open browser developer tools (F12) → **Network** tab
3. Refresh the page
4. Look for the following requests:
   - Google Analytics: `https://www.googletagmanager.com/gtag/js`
   - Umami: Your configured script URL

You can also check the page source code and look for the injected script in the `<head>` section.

---

### Troubleshooting

**Analytics tools not working?**

1. ✅ Verify that environment variables are set correctly
2. ✅ Restart the application after changing variables
3. ✅ Check the browser console for errors
4. ✅ Ensure the Measurement ID/Website ID format is correct
5. ✅ Check if ad blockers are interfering

**Docker Users:**

```bash
# Check if environment variables are set
docker exec new-api env | grep -E "GOOGLE_ANALYTICS|UMAMI"
```

---

### Privacy Considerations

- Google Analytics collects user data according to the [Google Privacy Policy](https://policies.google.com/privacy)
- Umami is privacy-focused and does not collect personal data
- If using analytics tools, consider adding a privacy policy to your website
- Both tools, when configured correctly, can comply with GDPR requirements

---

## Environment Variable Reference

| Variable | Required | Default Value | Description |
|------|------|--------|------|
| `GOOGLE_ANALYTICS_ID` | No | - | Google Analytics 4 Measurement ID (Format: G-XXXXXXXXXX)|
| `UMAMI_WEBSITE_ID` | No | - | Umami Website ID (UUID format)|
| `UMAMI_SCRIPT_URL` | No | `https://analytics.umami.is/script.js` | Umami script URL (Only required for self-hosted)|

---

## Related Links

- [Google Analytics](https://analytics.google.com/)
- [Umami Analytics](https://umami.is/)
- [Umami Documentation](https://umami.is/docs)
- [Google Analytics Privacy](https://support.google.com/analytics/answer/6004245)

---

## Support

If you encounter any issues or have questions, please:
- Submit an issue on [GitHub](https://github.com/Calcium-Ion/new-api/issues)
- Check existing issues for solutions