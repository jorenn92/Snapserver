import flask
import os
from subprocess import call
from flask import request

app = flask.Flask(__name__)
app.config["DEBUG"] = False


@app.route('/api/v1/bluetooth/connect', methods=['GET'])
def bluetooth_connect():
    if 'mac' in request.args:
            os.environ["BLUETOOTH_CLIENT"] = str(request.args['mac'])
            call("./bluetooth_connect.sh")
    else:
            return "Error: No mac field provided. Please specify a bluetooth mac address."
app.run(host='0.0.0.0', port=8025)