#!/bin/bash
set -eu

# Script to install Polish dictionary files into PostgreSQL and set up full-text search
# Usage: ./install_polish_dict.sh <DB_NAME> <DB_USER> [DB_HOST] [DB_PORT]
# Assumes polish.affix, polish.dict, and polish.stop are in the current working directory

DB_NAME=$1
DB_USER=$2
DB_HOST=${3:-localhost}
DB_PORT=${4:-5432}

SHAREDIR=$(pg_config --sharedir)
TSEARCH_DIR="$SHAREDIR/tsearch_data"

if [ ! -d "$TSEARCH_DIR" ]; then
  echo "tsearch_data directory not found. Creating it..."
  sudo mkdir -p "$TSEARCH_DIR"
fi

cp polish.affix "$TSEARCH_DIR/polish.affix"
cp polish.dict "$TSEARCH_DIR/polish.dict"
cp polish.stop "$TSEARCH_DIR/polish.stop"

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
