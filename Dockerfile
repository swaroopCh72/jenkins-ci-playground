FROM python:3.11.14-alpine3.23

WORKDIR /app

RUN apt-get update && apt-get install -y curl \
    && rm -f /var/lib/apt/lists/*

COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ .

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
