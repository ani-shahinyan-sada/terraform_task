FROM python:3.9-alpine

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy application files
COPY app.py .
COPY templates/ templates/

EXPOSE 8080

# Run Flask app instead of static server
CMD ["python", "app.py"]