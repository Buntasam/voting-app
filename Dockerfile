FROM docker.io/python:3.13

ADD /azure-vote /app
WORKDIR /app
RUN pip install -r requirements.txt

EXPOSE 80
CMD ["gunicorn", "--bind", "0.0.0.0:80", "--workers", "4", "main:app"]
HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost/ || exit 1