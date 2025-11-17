#!/bin/sh

# Development server script after switching to mkdocs-static-i18n

# Ensure mkdocs-static-i18n plugin is installed inside container
if ! pip show mkdocs-static-i18n >/dev/null 2>&1; then
  echo "📦 Installing mkdocs-static-i18n plugin..."
  pip install --no-cache-dir mkdocs-static-i18n[material]
fi

echo "🚀 Starting development server with i18n (hot-reload)..."

echo "📱 Chinese version: http://0.0.0.0:8000"
echo "📱 English version: http://0.0.0.0:8000/en/"
echo "📱 Japanese version: http://0.0.0.0:8000/ja/"
echo "🔥 Hot-reload enabled for docs & custom theme"
echo "🛑 Press Ctrl+C to stop the server"

# Start mkdocs with enhanced hot reload
# --watch-theme: Monitor theme directory for changes
# --dirtyreload: Faster incremental reload (only rebuild changed pages)
mkdocs serve --dev-addr 0.0.0.0:8000 --watch-theme --dirtyreload 