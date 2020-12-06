import flask
from subprocess import call


app = flask.Flask(__name__)
app.config["DEBUG"] = True


@app.route('/api/v1/bluetooth/connect', methods=['GET'])
def bluetooth_connect():
    if 'mac' in request.args:
            os.environ["BLUETOOTH_CLIENT"] = string(request.args['mac'])
            call("./bluetooth_connect.sh")
    else:
            return "Error: No mac field provided. Please specify a bluetooth mac address."
app.run(host='127.0.0.1', port=8025)