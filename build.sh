#!/bin/bash

# Multi-language build script for New API Docs

echo "🚀 Starting multi-language build for New API Docs..."

# Build Chinese version (default)
echo "📖 Building Chinese version..."
mkdocs build -f mkdocs.yml -d site

# Build English version
echo "📖 Building English version..."
mkdocs build -f mkdocs.en.yml -d site/en

echo "✅ Multi-language build completed!"