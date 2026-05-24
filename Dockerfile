# trump-archive/Dockerfile
FROM python:3.11-slim

# System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt \
    && python -m textblob.download_corpora

# Copy source
COPY . .

# Create output directories
RUN mkdir -p data/raw data/cleaned data/processed \
             export/markdown export/pdf export/html export/csv \
             logs

ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app

# Default: run full pipeline
CMD ["python", "-m", "app.main"]
