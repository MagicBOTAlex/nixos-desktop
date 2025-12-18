#!/usr/bin/env bash
set -e  # Exit immediately if a command exits with a non-zero status

# --- CONFIGURATION ---
# The Flake URI (usually just '.' if running from the repo root)
FLAKE_URI="."

# The destination URL for your cache.
# Examples:
#   SSH:  "ssh://nix-user@cache.deprived.dev"
#   S3:   "s3://my-bucket?endpoint=https://cache.deprived.dev&scheme=https"
CACHE_DEST="ssh://botserver@192.168.50.82"

# Path to your private signing key (optional but recommended)
# Leave empty if your remote store handles signing or doesn't require it.
SIGNING_KEY="./secret-key.pem"

# The NixOS configuration name (defaults to current hostname)
HOST_NAME=$(hostname)

# ---------------------

echo "🚀 Starting Build & Push for host: $HOST_NAME"

# 1. Build the system closure
# We use --print-out-paths so we can capture the result path into a variable
echo "🔨 Building system closure..."
OUT_PATH=$(nix build "${FLAKE_URI}#nixosConfigurations.${HOST_NAME}.config.system.build.toplevel" \
    --print-out-paths \
    --no-link)

echo "✅ Build complete: $OUT_PATH"

# 2. (Optional) Sign the paths
if [[ -n "$SIGNING_KEY" && -f "$SIGNING_KEY" ]]; then
    echo "✍️  Signing paths..."
    # We recursively sign the output path and all its dependencies
    nix store sign --key-file "$SIGNING_KEY" --recursive "$OUT_PATH"
fi

# 3. Push to Cache
echo "fw📤 Pushing closure to $CACHE_DEST..."
# We copy the build output. Nix automatically calculates the closure (dependencies)
# and pushes everything required that isn't already on the remote.
nix copy --to "$CACHE_DEST" "$OUT_PATH"

echo "🎉 Success! All packages pushed to cache.deprived.dev"
