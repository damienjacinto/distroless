from flask import Flask, request
import pprint
import logging

app = Flask(__name__)
app.config.from_object('project.config.DevelopmentConfig')
gunicorn_logger = logging.getLogger('gunicorn.error')
app.logger.handlers = gunicorn_logger.handlers
app.logger.setLevel(gunicorn_logger.level)

@app.route("/test")
def hello_world():
    app.logger.error("Request Headers %s", pprint.pprint(request.headers))
    headers_list = request.headers.getlist("X-Forwarded-For")
    if len(headers_list):
        app.logger.error(f"X-Forwarded-For: {headers_list}")
    else:
        app.logger.error(f"remote_addr: {request.remote_addr}")
    return "Hello World!"
