# File: superheroes.py

import firebase_admin
from firebase_admin import db
import flask
import time

app = flask.Flask(__name__)

# Local Test Env
from database import *

firebase_admin.initialize_app(cred, options={
    'databaseURL': 'https://easystroll.firebaseio.com/'
})


# # Production Env
# firebase_admin.initialize_app(options={
#     'databaseURL': 'https://easystroll.firebaseio.com/'
# })
#

def refresh_lists():
    walkers = get_walker_list()
    clients = get_client_list()
    for ccid in walkers:
        walker_list.add(ccid)
    for uid in clients:
        client_list.add(uid)


walker_list = set()
client_list = set()

db_root = db.reference()


def get_walker_list():
    return db_root.child('walker').get(shallow=True).keys()


def get_client_list():
    return db_root.child('client').get(shallow=True).keys()


@app.route('/')
def push_test():
    # fb_resp = walker.child('time').update({'TestTime': time.time()})
    return flask.jsonify(db_root.get())


@app.route('/gps', methods=['GET'])
def gps_update_test():
    ccid = flask.request.args.get('ccid')
    if ccid not in walker_list:
        refresh_lists()
        if ccid not in walker_list:
            return 'Invalid or not registered walker ID!'

    lat = flask.request.args.get('lat')
    lon = flask.request.args.get('lon')

    db_root.child('walker/'+str(ccid)+'/gps/'+str(int(time.time()))).update({'lat': float(lat), 'lon': float(lon)})
    return flask.jsonify(db_root.get())



if __name__ == '__main__':
    # This is used when running locally only. When deploying to Google App
    # Engine, a webserver process such as Gunicorn will serve the app. This
    # can be configured by adding an `entrypoint` to app.yaml.

    # Flask's development server will automatically serve static files in
    # the "static" directory. See:
    # http://flask.pocoo.org/docs/1.0/quickstart/#static-files. Once deployed,
    # App Engine itself will serve those files as configured in app.yaml.
    refresh_lists()
    app.run(host='127.0.0.1', port=8080, debug=True)
