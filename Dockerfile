FROM python:3.9.7-slim

COPY ./app /app

RUN cp /etc/apt/sources.list /etc/apt/sources.list~ && \
    sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list

RUN apt-get update
RUN mkdir -p /data

RUN apt-get build-dep -y python3-lxml && \
    apt-get install -y python3-lxml
    
RUN pip3 install --upgrade pip && \
    pip3 install --no-cache-dir -r /app/requirement.txt

CMD ["python3", "app/gazpar2mqtt.py"]
