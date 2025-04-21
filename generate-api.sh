#!/bin/bash

set -e

JAR_VERSION="7.6.0"
JAR_NAME="openapi-generator-cli-${JAR_VERSION}.jar"
JAR_PATH="./api-gen-cli/${JAR_NAME}"
JAR_URL="https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/${JAR_VERSION}/${JAR_NAME}"

OPENAPI_SPEC_URL="https://api.sgnl.pro/openapi/v1/schema.yml"
# Generator cleanup files
CLEANUP_FILES=(
  ".gitignore"
  ".npmignore"
  ".openapi-generator-ignore"
  ".openapi-generator"
  "git_push.sh"
)

# Check for Java
echo "🔍 Checking for Java..."
if ! command -v java &> /dev/null; then
  echo "❌ Java is not installed. Please install it first."
  exit 1
fi
echo "✅ Java is installed."

# Check and download JAR
mkdir -p "$(dirname "$JAR_PATH")"
if [ ! -f "$JAR_PATH" ]; then
  echo "⬇️  Downloading openapi-generator-cli $JAR_VERSION..."
  curl -L "$JAR_URL" -o "$JAR_PATH"
else
  echo "📦 Generator already exists at $JAR_PATH"
fi

# Language selection
echo ""
echo "🛠️  Select target language:"
echo "1) TypeScript (Axios)"
echo "2) C#"
echo "3) Python"
read -rp "Enter option [1-3]: " LANG_CHOICE

case "$LANG_CHOICE" in
  1) GENERATOR="typescript-axios" ;;
  2) GENERATOR="csharp" ;;
  3) GENERATOR="python" ;;
  *) echo "❌ Invalid choice. Exiting." && exit 1 ;;
esac

# Output directory (required argument)
OUTPUT_DIR="$1"

if [ -z "$OUTPUT_DIR" ]; then
  echo "❌ Please provide an output directory as the first argument."
  echo "Usage: ./generate-api.sh ./output/folder"
  exit 1
fi

echo "🚀 Generating client for '$GENERATOR'..."
java -jar "$JAR_PATH" generate \
  --generator-name "$GENERATOR" \
  --additional-properties supportsES6=true \
  --type-mappings DateTime=Date \
  --engine "mustache" \
  --input-spec "$OPENAPI_SPEC_URL" \
  --output "$OUTPUT_DIR" \
  --skip-validate-spec

# Cleanup
echo "🧹 Cleaning up extra generator files..."
for file in "${CLEANUP_FILES[@]}"; do
  TARGET="$OUTPUT_DIR/$file"
  if [ -e "$TARGET" ]; then
    rm -rf "$TARGET"
    echo "🗑️  Removed $file"
  fi
done

echo "✅ Done! Client generated at: $OUTPUT_DIR"
