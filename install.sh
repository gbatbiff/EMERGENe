#!/usr/bin/env bash
set -e

if [ -z "$CONDA_PREFIX" ]; then
  echo "Error: No active Conda environment detected. Activate your environment first."
  exit 1
fi

REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cat << INNER_EOF > "$CONDA_PREFIX/bin/EMERGENe"
#!/usr/bin/env bash
exec Rscript "$REPO_DIR/R/EMERGENe.R" "\$@"
INNER_EOF

chmod +rx "$CONDA_PREFIX/bin/EMERGENe"
echo "Success: 'EMERGENe' registered in $CONDA_PREFIX/bin/EMERGENe"
