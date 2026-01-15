FROM mcr.microsoft.com/devcontainers/base:bookworm

# Create a shim that executes the generator script from the workspace
# This allows the script to be updated without rebuilding the container
RUN echo '#!/bin/bash\nexec "${CODESPACE_VSCODE_FOLDER:-/workspaces/aws-identity-management}/.devcontainer/iam_identity_center_generator.sh" "$@"' > /usr/local/bin/iam_identity_center_generator \
    && chmod +x /usr/local/bin/iam_identity_center_generator
