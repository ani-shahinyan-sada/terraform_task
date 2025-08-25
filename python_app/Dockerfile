FROM python:3.9-alpine

WORKDIR /python_app

# Install dependencies
RUN pip install Flask==2.3.3 PyMySQL==1.1.0

# Copy application files
COPY python_app/app.py .

EXPOSE 8080

# Run Flask app instead of static server
CMD ["python", "app.py"]