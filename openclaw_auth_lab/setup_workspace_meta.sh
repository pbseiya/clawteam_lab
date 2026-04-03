#!/usr/bin/env bash
# -----------------------------------------------------------------
# setup_workspace_meta.sh – prepares the workspace_meta directory
# and creates symlinks for OpenClaw markdown files.
# -----------------------------------------------------------------

# Resolve the directory of this script (project root)
SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")

# 1. Ensure required directories exist
mkdir -p "${SCRIPT_DIR}/app"
mkdir -p "${SCRIPT_DIR}/workspace_meta"

# 2. Initialise OpenClaw workspace (creates markdown files if missing)
openclaw setup --workspace "${SCRIPT_DIR}/app"

# 3. Helper to move a file if it exists
move_md_if_exists() {
  local src="$1"
  local dst_dir="$2"
  if [[ -f "$src" ]]; then
    mv "$src" "$dst_dir/"
  fi
}

# 4. Move markdown files to workspace_meta
move_md_if_exists "${SCRIPT_DIR}/app/AGENTS.md"   "${SCRIPT_DIR}/workspace_meta"
move_md_if_exists "${SCRIPT_DIR}/app/SOUL.md"    "${SCRIPT_DIR}/workspace_meta"
move_md_if_exists "${SCRIPT_DIR}/app/IDENTITY.md" "${SCRIPT_DIR}/workspace_meta"

# 5. Create (or replace) symlinks back into app/
ln -sf "${SCRIPT_DIR}/workspace_meta/AGENTS.md"   "${SCRIPT_DIR}/app/AGENTS.md"
ln -sf "${SCRIPT_DIR}/workspace_meta/SOUL.md"    "${SCRIPT_DIR}/app/SOUL.md"
ln -sf "${SCRIPT_DIR}/workspace_meta/IDENTITY.md" "${SCRIPT_DIR}/app/IDENTITY.md"

# End of script
