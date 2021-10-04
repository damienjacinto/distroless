# base image debian:11
FROM python:3.9.7

# add requirements
COPY ./requirements.txt .

# install requirements
RUN apt-get update && apt-get upgrade -yq --no-install-recommends && \
    pip install -r requirements.txt && \
    rm requirements.txt && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# add user non-root 
RUN useradd --user-group --system --create-home --no-log-init myapp
USER myapp

# set working dir
WORKDIR /home/myapp

# copy app code
COPY ./src .

# launch falsk app
ENV FLASK_APP /home/myapp/app/project/app.py
CMD flask run --host=0.0.0.0 --port=5000
