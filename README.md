# Polish dictionary for PostgreSQL full-text search

This repository provides ready-to-use Polish dictionary files and scripts for enabling Polish language support in PostgreSQL's full-text search.

**Usage:**

1. Download dictionary files (`polish.affix`, `polish.dict`, `polish.stop`) from the [GitHub Releases](https://github.com/bartosz121/postgres-polish-dictionary/releases) page
   (or generate them manually with `./build.sh` and obtain `polish.stop` by cloning this repository).
2. Install into PostgreSQL:
   `./install_polish_dict.sh <DB_NAME> <DB_USER> [DB_HOST] [DB_PORT]`
3. Test:
   `SELECT * FROM ts_debug('pl_ispell', 'Bekasy nie wytsymały. Fetor przepłoszył je z terenów lęgowych. Ryby, w Morskim Łoku zdechły, a w Carnym Stawie, zdechły');`

---

### References:
- https://sjp.pl/sl/ort/
- https://www.postgresql.org/docs/current/textsearch.html
- https://www.postgresql.org/docs/current/textsearch-dictionaries.html#TEXTSEARCH-DICTIONARIES