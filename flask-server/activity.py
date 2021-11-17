import math
import secret
import psycopg2
from app import app, socket
from flask import request, make_response
from flask_socketio import SocketIO, emit, send

@app.route('/activity/create', methods=['GET', 'POST'])
def create_activity():
    if request.args.get('owner') is None or request.args.get('actname') is None \
    or request.args.get('actdesc') is None or request.args.get('actlat') is None \
    or request.args.get('actlong') is None or request.args.get('creationtime') is None:
        return make_response('{"Bad Request": "Check URL"}', 400)

    ownerReceived = format(request.args.get('owner'))
    nameReceived = format(request.args.get('actname'))
    descReceived = format(request.args.get('actdesc'))
    latitudeReceived = format(request.args.get('actlat'))
    longitudeReceived = format(request.args.get('actlong'))
    timestampReceived = format(request.args.get('creationtime'))

    new_Activity = [ownerReceived, nameReceived, descReceived, latitudeReceived, longitudeReceived, timestampReceived]

    conn = psycopg2.connect(dbname='coredb', user='postgres', host='localhost', password=secret.getDbPass())

    cursor = conn.cursor()
    SQL = 'INSERT INTO "activities" (owner, act_name, act_desc, act_latitude, act_longitude, time) ' \
          'VALUES (%s, %s, %s, %s, %s, %s);'

    with conn, conn.cursor() as cursor:
        cursor.execute(SQL, [ownerReceived, nameReceived, descReceived, latitudeReceived, longitudeReceived, timestampReceived])

    status = cursor.statusmessage
    conn.close()
    print(status)

    try:
        if str(status) is not "None":
            send_new_event(str(new_Activity))
            return make_response('{"ActivityCreated": "true"}', 200)
    except Exception as e:
        return make_response('{"ActivityCreated": "false"}', 404)

@app.route('/activity/fetch', methods=['GET', 'POST'])
def fetch_ranged_activities():
    if request.args.get('userlat') is None or request.args.get('userlong') is None \
            or request.args.get('userradius') is None:
        return make_response('{"Bad Request": "Check URL"}', 400)

    latitudeReceived = format(request.args.get('userlat'))
    longitudeReceived = format(request.args.get('userlong'))
    userRadiusReceived = format(request.args.get('userradius'))

    conn = psycopg2.connect(dbname='coredb', user='postgres', host='localhost', password=secret.getDbPass())

    cursor = conn.cursor()
    SQL = 'SELECT * FROM "activities" WHERE acos(sin(%s) * ' \
          'sin(RADIANS(act_latitude)) + cos(%s) * cos(RADIANS(act_latitude)) ' \
          '* cos(RADIANS(act_longitude) - (%s))) * 3958.8 <= %s; '

    user_lat_radians = math.radians(float(latitudeReceived))
    user_long_radians = math.radians(float(longitudeReceived))

    with conn, conn.cursor() as cursor:
        cursor.execute(SQL, [user_lat_radians, user_lat_radians, user_long_radians, userRadiusReceived])

        all_activities = cursor.fetchall()

    print(all_activities)

    try:
        if (len(str(all_activities))==2):
            return make_response('{"ActivitiesFound": "false"}', 200)

        elif str(all_activities) is not "None":
            return make_response('{"ActivitiesFound: ": ' + str(all_activities) + '}', 200)

    except Exception as e:
        return make_response('{"ErrorWhileFetching": '+str(e)+'}', 404)


@app.route('/activity/adduser', methods=['GET', 'POST'])
def add_user():
    return "ready to read"


@socket.on('connected')
def handle_id(data):
    print(data)

@socket.on('message')
def send_new_event(activity):
    print('Sent activity: ' + activity)
    send(activity, broadcast=True, namespace="")
