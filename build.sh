#!/bin/bash
set -eu

# Script to download, unpack, and convert Polish dictionary files for PostgreSQL full-text search
# Usage: ./script.sh [SJP_DATE] (e.g., ./script.sh 20250901)
# If no SJP_DATE is provided, defaults to 20250901

SJP_DATE=${1:-20250901}

# Step 1: Download the file
wget "https://sjp.pl/sl/ort/sjp-ispell-pl-${SJP_DATE}-src.tar.bz2"

# Step 2: Unpack the file
tar -xvf "sjp-ispell-pl-${SJP_DATE}-src.tar.bz2"

# Step 3: Convert polish.aff file
iconv -f ISO_8859-2 -t utf-8 "sjp-ispell-pl-${SJP_DATE}/polish.aff" > polish.affix

# Step 4: Convert polish.all file
iconv -f ISO_8859-2 -t utf-8 "sjp-ispell-pl-${SJP_DATE}/polish.all" > polish.dict

echo "Files created: polish.affix and polish.dict"