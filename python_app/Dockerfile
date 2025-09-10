FROM python:3.9-alpine

WORKDIR /python_app

RUN pip install Flask==2.3.3 PyMySQL==1.1.0

COPY app.py .

EXPOSE 8080

CMD ["python", "app.py"]