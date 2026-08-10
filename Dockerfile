FROM python:3.12-slim-trixie

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH="/app:/app/multi_doc_chat"

# Set working directory
WORKDIR /app

# Install OS dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        poppler-utils \
        curl && \
    rm -rf /var/lib/apt/lists/*
    
# Copy dependency file first for better Docker layer caching
COPY requirements.txt .

# Upgrade pip and install Python dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Expose application port
EXPOSE 8080

# Run FastAPI application
CMD ["uvicorn" , "main:app" , "--host" , "0.0.0.0" , "--port" , "8080" , "--reload" ]