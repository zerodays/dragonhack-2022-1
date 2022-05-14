FROM python:3.10-slim

WORKDIR /app

RUN pip install wheel

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["gunicorn", "--bind", ":8000", "--access-logfile", "-", "--workers", "2", "backend.wsgi:application"]
