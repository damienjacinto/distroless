FROM python:3.9.7

# set working directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# add requirements
ADD ./requirements.txt /usr/src/app/requirements.txt

# install requirements
RUN pip install -r requirements.txt

COPY ./src /usr/src/app

ENV FLASK_APP /usr/src/app/project/app.py

CMD flask run --host=0.0.0.0 --port=80
