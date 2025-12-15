# syntax=docker/dockerfile:1.4

FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV RUN_MODE=api

CMD ["/bin/sh", "-c", "if [ \"$RUN_MODE\" = 'worker' ]; then python worker.py; else uvicorn api:app --host 0.0.0.0 --port 8080; fi"]