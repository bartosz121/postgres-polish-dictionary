#!/bin/bash
set -eu

# Script to install Polish dictionary files into PostgreSQL and set up full-text search
# Usage: ./install_polish_dict.sh <DB_NAME> <DB_USER> [DB_HOST] [DB_PORT] [--no-copy]

# Parse arguments and remove --no-copy if present
NO_COPY=0
ARGS=()
for arg in "$@"; do
  if [ "$arg" = "--no-copy" ]; then
    NO_COPY=1
  else
    ARGS+=("$arg")
  fi
done

DB_NAME=${ARGS[0]}
DB_USER=${ARGS[1]}
DB_HOST=${ARGS[2]:-localhost}
DB_PORT=${ARGS[3]:-5432}

SHAREDIR=$(pg_config --sharedir)
TSEARCH_DIR="$SHAREDIR/tsearch_data"

if [ ! -d "$TSEARCH_DIR" ]; then
  echo "tsearch_data directory not found. Creating it..."
  sudo mkdir -p "$TSEARCH_DIR"
fi

if [ "$NO_COPY" -eq 0 ]; then
  cp polish.affix "$TSEARCH_DIR/polish.affix"
  cp polish.dict "$TSEARCH_DIR/polish.dict"
  cp polish.stop "$TSEARCH_DIR/polish.stop"
fi

psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "
CREATE TEXT SEARCH DICTIONARY pl_ispell (
  Template = ispell,
  DictFile = polish,
  AffFile = polish,
  StopWords = polish
);

CREATE TEXT SEARCH CONFIGURATION pl_ispell (
  PARSER = default
);

ALTER TEXT SEARCH CONFIGURATION pl_ispell
  ALTER MAPPING FOR asciiword, asciihword, hword_asciipart, word, hword, hword_part
  WITH pl_ispell;
"

echo "Installation complete. Verifying installation..."
psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c \
  "SELECT * FROM ts_debug('pl_ispell', 'Bekasy nie wytsymały. Fetor przepłoszył je z terenów lęgowych. Ryby, w Morskim Łoku zdechły, a w Carnym Stawie, zdechły');"
