#!/bin/sh

# Development server script for New API Docs
# This script builds both Chinese and English versions and serves them together

echo "🚀 Starting development server for New API Docs..."

# Build both versions first
echo "📖 Building Chinese version..."
mkdocs build -f mkdocs.yml -d site

echo "📖 Building English version..."
mkdocs build -f mkdocs.en.yml -d site/en

echo "✅ Build completed!"

# Start static file server
echo "🌐 Starting development server..."
echo "📱 Chinese version: http://127.0.0.1:8000"
echo "📱 English version: http://127.0.0.1:8000/en/"
echo "🛑 Press Ctrl+C to stop the server"

# Start Python HTTP server in the site directory
cd site && python3 -m http.server 8000 