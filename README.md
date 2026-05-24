# 📚 Trump Archive Project

**A comprehensive, modular Python system for collecting, archiving, and publishing publicly available statements made by Donald J. Trump across multiple platforms — exported as a professional PDF book, interactive HTML timeline, and structured data.**

---

[![Python](https://img.shields.io/badge/Python-3.11%2B-blue?logo=python)](https://python.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![GitHub Actions](https://img.shields.io/badge/CI-GitHub%20Actions-black?logo=github)](/.github/workflows)

---

## 🗂 Table of Contents

1. [Overview](#overview)
2. [Features](#features)
3. [Architecture](#architecture)
4. [Supported Sources](#supported-sources)
5. [Installation](#installation)
6. [Quick Start](#quick-start)
7. [Usage](#usage)
8. [Output Structure](#output-structure)
9. [Book Format](#book-format)
10. [Configuration](#configuration)
11. [Analytics Modules](#analytics-modules)
12. [Docker Support](#docker-support)
13. [GitHub Actions](#github-actions)
14. [Legal & Ethical Notes](#legal--ethical-notes)
15. [Contributing](#contributing)
16. [License](#license)

---

## Overview

The Trump Archive Project is a production-ready Python toolkit that:

- **Collects** publicly available posts, statements, speeches, and declarations from multiple platforms
- **Processes** them into a clean, deduplicated, chronologically sorted dataset
- **Analyses** them for sentiment, keyword frequency, and engagement trends
- **Exports** a professionally typeset PDF book with chapters by year, a table of contents, keyword index, and source citations
- **Generates** an interactive HTML timeline with full-text search and platform/year filters

All content is sourced **exclusively from public platforms and official archives**. No authentication bypass, private data, or ToS violations are involved.

---

## Features

### Core
- ✅ Multi-platform async collection (aiohttp)
- ✅ Automatic deduplication with content hashing
- ✅ Repost / retweet detection and labelling
- ✅ Retry logic with exponential back-off
- ✅ Rate-limit handling (Retry-After header support)
- ✅ Resume interrupted downloads
- ✅ Structured logging with file + console output

### Export Formats
- ✅ **PDF book** — professional typeset archive (ReportLab)
- ✅ **Markdown** — one chapter file per year
- ✅ **HTML** — interactive self-contained timeline
- ✅ **JSON** — structured dataset (raw + cleaned)
- ✅ **CSV** — flat table for spreadsheet analysis

### Analytics
- ✅ **Sentiment analysis** (TextBlob; Hugging Face optional)
- ✅ **Keyword indexing** with frequency counts and post references
- ✅ **Timeline visualisation** — activity charts, platform pie charts (matplotlib)
- ✅ **Per-year and per-platform aggregations**

### Book Quality
- ✅ Full-bleed cover page with typographic design
- ✅ Automatic table of contents with page numbers
- ✅ Year chapters with monthly sections
- ✅ Post blockquotes with platform colour coding
- ✅ Engagement statistics per post
- ✅ Source citations and URLs
- ✅ PDF metadata (title, author, keywords, creator)
- ✅ Running headers/footers with page numbers

---

## Architecture

```
trump-archive/
│
├── app/                        # Core application logic
│   ├── main.py                 # Pipeline orchestrator & CLI
│   ├── config.py               # Central configuration
│   ├── utils.py                # Post model, HTTP helpers, deduplication
│   ├── markdown_generator.py   # Markdown chapter writer
│   └── pdf_generator.py        # ReportLab PDF book generator
│
├── collectors/                 # Platform-specific collectors
│   ├── twitter.py              # X/Twitter (sample + Wayback CDX)
│   ├── truthsocial.py          # Truth Social (Mastodon API)
│   ├── facebook.py             # Facebook (sample + CrowdTangle optional)
│   ├── instagram.py            # Instagram (sample mode)
│   ├── youtube.py              # YouTube (community posts + transcripts)
│   └── statements.py           # Official statements & speeches
│
├── analytics/
│   ├── sentiment.py            # TextBlob sentiment analysis
│   ├── keywords.py             # Keyword extraction & indexing
│   └── timeline.py             # Activity charts & HTML timeline
│
├── data/
│   ├── raw/                    # Per-platform raw JSON
│   ├── cleaned/                # Master deduplicated dataset
│   └── processed/              # Analytics outputs
│
├── export/
│   ├── markdown/               # Year chapter .md files
│   ├── pdf/                    # Generated PDF books
│   ├── html/                   # Interactive HTML timeline
│   └── csv/                    # Flat CSV exports
│
├── logs/                       # Runtime logs
├── .github/workflows/          # GitHub Actions automation
├── Dockerfile                  # Container support
├── requirements.txt
└── README.md
```

---

## Supported Sources

| Source | Method | Auth Required | Notes |
|--------|--------|--------------|-------|
| X / Twitter | Sample + Wayback CDX API | ❌ No | Account suspended Jan 2021 |
| Truth Social | Mastodon-compatible public API | ❌ No | Public accounts only |
| Facebook | Sample + CrowdTangle (optional) | ⚠️ Optional | CrowdTangle needs academic token |
| Instagram | Sample only (ToS restricted) | ❌ Sample | Auth scraping not implemented |
| YouTube | Data API v3 | ⚠️ Optional | Free API key for community posts |
| White House Archives | Static public records | ❌ No | trumpwhitehouse.archives.gov |
| Campaign Statements | Public website | ❌ No | donaldjtrump.com |

---

## Installation

### Prerequisites

- Python 3.11+
- pip

### 1. Clone the repository

```bash
git clone https://github.com/youruser/trump-archive.git
cd trump-archive
```

### 2. Create a virtual environment (recommended)

```bash
python -m venv .venv
source .venv/bin/activate      # Linux/macOS
.venv\Scripts\activate         # Windows
```

### 3. Install dependencies

```bash
pip install -r requirements.txt
```

### 4. Download NLP data (one-time)

```bash
python -m textblob.download_corpora
```

---

## Quick Start

### Generate the complete archive (PDF + all outputs)

```bash
python -m app.main
```

This runs the full pipeline:
1. Collects from all enabled platforms
2. Deduplicates and cleans the dataset
3. Runs sentiment analysis and keyword indexing
4. Generates Markdown chapters
5. Generates the PDF book
6. Creates the interactive HTML timeline

**Output:** `export/pdf/trump_archive.pdf`

---

## Usage

### CLI Reference

```bash
# Full pipeline (default)
python -m app.main

# Regenerate PDF from cached data only
python -m app.main --pdf-only

# Collect and analyse, skip PDF generation
python -m app.main --no-pdf

# Limit to specific platforms
python -m app.main --platforms twitter truthsocial statements

# Custom PDF filename
python -m app.main --output "archive_2024.pdf"

# Full options
python -m app.main --help
```

### Programmatic Usage

```python
import asyncio
from app.main import run_pipeline

# Run full pipeline
pdf_path = asyncio.run(run_pipeline(
    platforms=["twitter", "truthsocial", "statements"],
    generate_pdf_flag=True,
    output_filename="my_archive.pdf",
))
print(f"PDF: {pdf_path}")
```

### Run Individual Collectors

```bash
# Twitter only
python -m collectors.twitter

# Truth Social only
python -m collectors.truthsocial

# Official statements
python -m collectors.statements
```

### Run Analytics Separately

```bash
# Sentiment analysis on existing data
python -m analytics.sentiment

# Keyword index
python -m analytics.keywords

# Timeline charts + HTML
python -m analytics.timeline
```

### Load a Local Twitter Archive

If you have access to a researcher-published tweet archive (e.g. the Trump Tweet Archive), place it at:

```
data/raw/twitter_archive.json
```

Expected format: a JSON list of objects with fields `id`, `text`, `date` (and optionally `favorites`, `retweets`, `isRetweet`).

The collector will automatically load it.

---

## Output Structure

After a full run:

```
export/
├── pdf/
│   └── trump_archive.pdf           # The PDF book
├── markdown/
│   ├── _title.md
│   ├── _toc.md
│   ├── _introduction.md
│   ├── _platform_overview.md
│   ├── 2012.md
│   ├── 2013.md
│   ├── ...
│   ├── 2024.md
│   └── _appendix.md
├── html/
│   └── timeline.html               # Interactive self-contained timeline
└── csv/
    └── all_posts.csv               # Flat CSV for analysis

data/
├── raw/
│   ├── twitter_raw.json
│   ├── truthsocial_raw.json
│   ├── facebook_raw.json
│   ├── instagram_raw.json
│   ├── youtube_raw.json
│   └── statements_raw.json
├── cleaned/
│   └── all_posts.json              # Master deduplicated dataset
└── processed/
    ├── sentiment_results.json
    ├── keyword_index.json
    └── timeline_data.json
```

---

## Book Format

The generated PDF follows professional political archive conventions:

| Section | Description |
|---------|-------------|
| **Cover Page** | Full-bleed typographic design, title, subtitle, platform list |
| **Table of Contents** | Auto-generated with page numbers |
| **Introduction** | Scope, methodology, platform table, disclaimer |
| **Archive Statistics** | Post counts, platform breakdown, engagement totals |
| **Year Chapters** | 2009 → present, organised by month |
| **Post Blocks** | Blockquote styling with platform colour, timestamp, metrics, citation |
| **Sentiment Overview** | Per-year polarity summary |
| **Appendix** | Keyword index, source references |

### PDF Styling

- **Page size:** US Letter (8.5" × 11") — or A4 (configurable)
- **Typography:** Times Roman / Helvetica — classic archive aesthetic
- **Colour:** Red accent (`#B22222`) + Navy (`#00205B`)
- **Print-safe:** Black & white printing works fully
- **Page numbers:** Running footers on every page
- **Bookmarks:** Chapter bookmarks in PDF viewer sidebar

---

## Configuration

All settings live in `app/config.py`:

```python
# Feature flags
ENABLE_SENTIMENT_ANALYSIS     = True
ENABLE_KEYWORD_INDEXING       = True
ENABLE_TIMELINE_VISUALIZATION = True
ENABLE_COLOR_PDF              = False   # True = premium colour edition

# PDF styling
PDF_CONFIG.page_size = "letter"   # or "A4"
PDF_CONFIG.font_body = "Times-Roman"

# Per-platform settings
COLLECTOR_SETTINGS["twitter"]["use_local_archive"] = True
COLLECTOR_SETTINGS["truthsocial"]["max_pages"] = 50

# Logging
LOG_LEVEL = "INFO"   # or "DEBUG" for verbose output
```

---

## Analytics Modules

### Sentiment Analysis (`analytics/sentiment.py`)

Uses **TextBlob** for lightweight offline sentiment scoring:
- **Polarity:** -1.0 (very negative) → +1.0 (very positive)
- **Subjectivity:** 0.0 (factual) → 1.0 (subjective)
- Per-post labels: `positive` / `neutral` / `negative`
- Per-year aggregations

To upgrade to Hugging Face (higher accuracy):
```bash
pip install transformers torch
# Then set USE_TRANSFORMERS=True in analytics/sentiment.py
```

### Keyword Indexing (`analytics/keywords.py`)

- Builds a reverse index: keyword → list of post IDs
- Tracks 40+ political terms specifically (MAGA, fake news, election, etc.)
- Outputs top keywords by year
- Generates the keyword index appendix for the PDF

### Timeline Visualisation (`analytics/timeline.py`)

- **Activity chart:** Monthly post volume over time (PNG via matplotlib)
- **Platform pie chart:** Post distribution by platform
- **Interactive HTML timeline:** Self-contained, filterable, searchable
- **JSON data:** `timeline_data.json` for custom downstream visualisations

---

## Docker Support

```bash
# Build the image
docker build -t trump-archive .

# Run full pipeline
docker run --rm -v $(pwd)/export:/app/export trump-archive

# Collect only, no PDF
docker run --rm -v $(pwd)/data:/app/data trump-archive \
  python -m app.main --no-pdf

# Custom platforms
docker run --rm -v $(pwd)/export:/app/export trump-archive \
  python -m app.main --platforms twitter statements
```

---

## GitHub Actions

The included workflow (`.github/workflows/daily_update.yml`) runs at 06:00 UTC daily:

1. Collects from all enabled platforms
2. Runs analytics
3. Generates a dated PDF (`trump_archive_YYYYMMDD.pdf`)
4. Uploads PDF + data as GitHub Actions artifacts (90-day retention)
5. Commits updated cleaned data back to the repository

### Enable the workflow

1. Push the repository to GitHub
2. Go to **Actions → Enable workflows**
3. The daily run starts automatically

### Manual trigger

```
GitHub → Actions → Daily Archive Update → Run workflow
```

---

## Legal & Ethical Notes

This project is built on strict ethical principles:

- ✅ **Public content only** — no authentication bypass, no private data
- ✅ **robots.txt respected** — all collectors honour platform policies
- ✅ **No scraping of restricted endpoints**
- ✅ **Rate limiting** — polite delays between all requests
- ✅ **Historical/research purpose** — fair use principles apply
- ✅ **Verbatim reproduction** — no alteration of original text
- ✅ **Source citations** — every post links to its original source

Supported source access methods:
- Truth Social: Mastodon-compatible public API (no auth required for public accounts)
- Twitter/X: Researcher-published datasets and Wayback Machine CDX API
- Facebook: Widely reported public posts
- White House Archives: National Archives (public domain government records)
- YouTube: YouTube Data API v3 (free tier)

**Disclaimer:** This archive is compiled for historical record-keeping and research. Inclusion of any statement does not constitute endorsement. All content belongs to its respective authors.

---

## Contributing

Contributions are welcome, particularly:

- Additional public archive sources
- Better Twitter/X archive dataset integration
- Improved OCR for image posts
- Speech-to-text integration for video content
- Additional language support
- Unit test coverage

Please read `CONTRIBUTING.md` (if present) and open an issue before large PRs.

---

## License

MIT License — see [LICENSE](LICENSE) for details.

---

*Trump Archive Project — Public Records Edition*  
*Built with Python · ReportLab · aiohttp · TextBlob · matplotlib*
