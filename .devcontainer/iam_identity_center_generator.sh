#!/bin/bash
# Script: iam_identity_center_generator.sh
# Purpose: Run the IAM Identity Center Generator using the published Docker image.
# Usage: iam_identity_center_generator [options]
#
# This script pulls and runs the latest generator container, passing through
# AWS credentials and outputting generated Terraform to the current directory.
#
# Config file handling:
#   - If .devcontainer/config.yaml exists, it's used automatically
#   - Use -c <file> to specify a different config file
#   - Relative paths are automatically translated to container paths
#
# Prerequisites:
#   - Docker
#   - AWS credentials exported (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN)
#   - AWS_REGION set to your Identity Center region
#
# Examples:
#   iam_identity_center_generator              # Uses .devcontainer/config.yaml if present
#   iam_identity_center_generator -c my.yaml   # Use my.yaml from current directory
#   iam_identity_center_generator -m true      # Enable TEAM support
#   iam_identity_center_generator -v verbose   # Verbose output

set -e

# Default image
DEFAULT_IMAGE="ghcr.io/robbycuenot/aws-identity-management-generator:latest"

# Config file location (uses Codespaces env var with fallback)
WORKSPACE_DIR="${CODESPACE_VSCODE_FOLDER:-/workspaces/aws-identity-management}"
CONFIG_FILE="$WORKSPACE_DIR/.devcontainer/config.yaml"

# Determine image source - Priority: Codespaces secrets > config.yaml > default
IMAGE_SOURCE="default"
IMAGE="$DEFAULT_IMAGE"

# Check config.yaml
if [ -f "$CONFIG_FILE" ]; then
    CONFIG_IMAGE=$(grep -E "^image:" "$CONFIG_FILE" 2>/dev/null | sed 's/image:[[:space:]]*//' | tr -d '"' | tr -d "'" || true)
    if [ -n "$CONFIG_IMAGE" ]; then
        IMAGE="$CONFIG_IMAGE"
        IMAGE_SOURCE="config.yaml"
    fi
fi

# Check Codespaces secrets (highest priority)
if [ -n "$GENERATOR_REPO_OWNER" ] && [ -n "$GENERATOR_REPO_NAME" ]; then
    OWNER_LOWER=$(echo "$GENERATOR_REPO_OWNER" | tr '[:upper:]' '[:lower:]')
    NAME_LOWER=$(echo "$GENERATOR_REPO_NAME" | tr '[:upper:]' '[:lower:]')
    IMAGE="ghcr.io/${OWNER_LOWER}/${NAME_LOWER}:latest"
    IMAGE_SOURCE="Codespaces secrets"
fi

echo "Image source: $IMAGE_SOURCE"
echo "Image: $IMAGE"

# Check for required AWS credentials
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "Error: AWS credentials not set."
    echo "Export AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, and AWS_SESSION_TOKEN"
    echo "You can copy these from your AWS access portal."
    exit 1
fi

if [ -z "$AWS_REGION" ]; then
    if [ -n "$AWS_DEFAULT_REGION" ]; then
        export AWS_REGION="$AWS_DEFAULT_REGION"
    else
        echo "Warning: AWS_REGION not set, defaulting to us-east-1"
        export AWS_REGION="us-east-1"
    fi
fi

echo "Pulling image..."
docker pull "$IMAGE"

# Process arguments to translate -c paths to container paths
PROCESSED_ARGS=()
SKIP_NEXT=false
USER_CONFIG_FILE=""

for i in "$@"; do
    if [ "$SKIP_NEXT" = true ]; then
        # This is the config file path after -c
        if [[ "$i" != /* ]]; then
            # Relative path - translate to /output/ container path
            USER_CONFIG_FILE="$i"
            PROCESSED_ARGS+=("/output/$i")
        else
            # Absolute path - use as-is (user knows what they're doing)
            PROCESSED_ARGS+=("$i")
        fi
        SKIP_NEXT=false
    elif [ "$i" = "-c" ]; then
        PROCESSED_ARGS+=("$i")
        SKIP_NEXT=true
    else
        PROCESSED_ARGS+=("$i")
    fi
done

# Build config mount if default config.yaml exists and -c not specified by user
CONFIG_MOUNT=""
CONFIG_ARG=""
if [ -z "$USER_CONFIG_FILE" ] && [ -f "$CONFIG_FILE" ]; then
    CONFIG_MOUNT="-v $CONFIG_FILE:/app/config.yaml"
    CONFIG_ARG="-c /app/config.yaml"
    echo "Using config.yaml from $CONFIG_FILE"
elif [ -n "$USER_CONFIG_FILE" ]; then
    echo "Using config file: $USER_CONFIG_FILE"
fi

echo "Running generator..."
docker run --rm -it \
    -e AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
    -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
    -e AWS_SESSION_TOKEN="$AWS_SESSION_TOKEN" \
    -e AWS_REGION="$AWS_REGION" \
    -e AWS_DEFAULT_REGION="$AWS_REGION" \
    -v "$(pwd):/output" \
    $CONFIG_MOUNT \
    "$IMAGE" \
    $CONFIG_ARG "${PROCESSED_ARGS[@]}"

echo ""
echo "Generation complete! Run 'terraform init && terraform plan' to verify."
