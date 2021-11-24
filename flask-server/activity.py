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
    or request.args.get('actlong') is None or request.args.get('creationtime') is None \
            or request.args.get('actaddress') is None:
        return make_response('{"Bad Request": "Check URL"}', 400)

    aid = ""
    ownerReceived = format(request.args.get('owner'))
    nameReceived = format(request.args.get('actname'))
    descReceived = format(request.args.get('actdesc'))
    latitudeReceived = format(request.args.get('actlat'))
    longitudeReceived = format(request.args.get('actlong'))
    timestampReceived = format(request.args.get('creationtime'))
    addressReceived = format(request.args.get('actaddress'))

    conn = psycopg2.connect(dbname='coredb', user='postgres', host='localhost', password=secret.getDbPass())

    cursor = conn.cursor()
    SQL = 'INSERT INTO "activities" (owner, act_name, act_desc, act_latitude, act_longitude, time, address) ' \
          'VALUES (%s, %s, %s, %s, %s, %s, %s) RETURNING aid;'

    with conn, conn.cursor() as cursor:
        cursor.execute(SQL, [ownerReceived, nameReceived, descReceived, latitudeReceived, longitudeReceived, timestampReceived, addressReceived])
        aid = str(cursor.fetchone()[0])

        status = cursor.statusmessage
    conn.close()
    new_activity = [aid, ownerReceived, nameReceived, descReceived, latitudeReceived, longitudeReceived, timestampReceived,
                    addressReceived]
    new_activity_json_value = ""
    for value in new_activity:
        if isinstance(value, str):
            new_activity_json_value = new_activity_json_value + "\"" + value + "\"" + ", "
        else:
            new_activity_json_value = new_activity_json_value + value + ", "
    new_activity_json_value = new_activity_json_value[:-2]

    print(new_activity_json_value)

    try:
        if str(status) is not "None":
            send_new_event('{"ActivityCreated": [[' + str(new_activity_json_value) + ']]}')
            return make_response('{"ActivityCreated": ' + aid + '}', 200)
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
    SQL = 'SELECT aid, owner, act_name, act_desc, act_latitude, act_longitude, pair, address FROM "activities" WHERE ' \
          'acos(sin(%s) * sin(RADIANS(act_latitude)) + cos(%s) * cos(RADIANS(act_latitude)) ' \
          '* cos(RADIANS(act_longitude) - (%s))) * 3958.8 <= %s; '

    user_lat_radians = math.radians(float(latitudeReceived))
    user_long_radians = math.radians(float(longitudeReceived))

    with conn, conn.cursor() as cursor:
        cursor.execute(SQL, [user_lat_radians, user_lat_radians, user_long_radians, userRadiusReceived])

        all_activities = cursor.fetchall()

    print(all_activities)
    all_activities_list = []
    all_activities_json_value = ""
    try:
        if (len(str(all_activities))==2):
            return make_response('{"ActivitiesFound": ["false"]}', 200)

        elif str(all_activities) is not "None":

            for inner_tuple in all_activities:
                all_activities_list.append(str(inner_tuple).replace("\'","\"").replace("(","[").replace(")","]").replace("None", "\"None\""))
            #print(all_activities_list)

            for activity in all_activities_list:
                all_activities_json_value = all_activities_json_value + activity + ", "

            all_activities_json_value = all_activities_json_value[:-2]
            print(all_activities_json_value)
            return make_response('{"ActivitiesFound": [' + str(all_activities_json_value) + ']}', 200)

    except Exception as e:
        return make_response('{"ErrorWhileFetching": '+str(e)+'}', 404)


@app.route('/activity/fetchGoing', methods=['GET', 'POST'])
def fetch_going_activities():
    if request.args.get("pair") is None:
        return make_response('{"Bad Request": "Check URL"}', 400)

    received = format(request.args.get("pair"))

    conn = psycopg2.connect(dbname='coredb', user='postgres', host='localhost', password=secret.getDbPass())

    cursor = conn.cursor()
    SQL = 'SELECT aid, owner, act_name, act_desc, act_latitude, act_longitude, pair, address FROM "activities" WHERE ' + \
          '(((length(pair) >0) AND owner=%s) OR (pair=%s));'

    with conn, conn.cursor() as cursor:
        cursor.execute(SQL, [received, received])

        all_activities = cursor.fetchall()

    print(all_activities)
    all_activities_list = []
    all_activities_json_value = ""
    try:
        if (len(str(all_activities)) == 2):
            return make_response('{"ActivitiesFound": ["false"]}', 200)

        elif str(all_activities) is not "None":

            for inner_tuple in all_activities:
                all_activities_list.append(
                    str(inner_tuple).replace("\'", "\"").replace("(", "[").replace(")", "]").replace("None",
                                                                                                     "\"None\""))
            # print(all_activities_list)

            for activity in all_activities_list:
                all_activities_json_value = all_activities_json_value + activity + ", "

            all_activities_json_value = all_activities_json_value[:-2]
            print(all_activities_json_value)
            return make_response('{"ActivitiesFound": [' + str(all_activities_json_value) + ']}', 200)
    except Exception as e:
        return make_response('{"ErrorWhileFetchingSentActivities": ' + str(e) + '}', 404)

@app.route('/activity/fetchSent', methods=['GET', 'POST'])
def fetch_sent_activities():
    return fetch_activities_generic('owner')

def fetch_activities_generic(whereField):
    if request.args.get(whereField) is None:
        return make_response('{"Bad Request": "Check URL"}', 400)

    received = format(request.args.get(whereField))

    conn = psycopg2.connect(dbname='coredb', user='postgres', host='localhost', password=secret.getDbPass())

    cursor = conn.cursor()
    SQL = 'SELECT aid, owner, act_name, act_desc, act_latitude, act_longitude, pair, address FROM "activities" WHERE ' + \
          whereField + '= %s'

    with conn, conn.cursor() as cursor:
        cursor.execute(SQL, [received])

        all_activities = cursor.fetchall()

    print(all_activities)
    all_activities_list = []
    all_activities_json_value = ""
    try:
        if (len(str(all_activities))==2):
            return make_response('{"ActivitiesFound": ["false"]}', 200)

        elif str(all_activities) is not "None":

            for inner_tuple in all_activities:
                all_activities_list.append(str(inner_tuple).replace("\'","\"").replace("(","[").replace(")","]").replace("None", "\"None\""))
            #print(all_activities_list)

            for activity in all_activities_list:
                all_activities_json_value = all_activities_json_value + activity + ", "

            all_activities_json_value = all_activities_json_value[:-2]
            print(all_activities_json_value)
            return make_response('{"ActivitiesFound": [' + str(all_activities_json_value) + ']}', 200)
    except Exception as e:
        return make_response('{"ErrorWhileFetchingSentActivities": '+str(e)+'}', 404)

@app.route('/activity/addUser', methods=['GET', 'POST'])
def add_user():
    if request.args.get("pair") is None:
        return make_response('{"Bad Request": "Check URL"}', 400)

    receivedActivityId = format(request.args.get("aid"))
    receivedPairId = format(request.args.get("pair"))

    conn = psycopg2.connect(dbname='coredb', user='postgres', host='localhost', password=secret.getDbPass())

    cursor = conn.cursor()
    SQL = 'UPDATE "activities" SET pair=%s WHERE aid = %s RETURNING aid, owner;'

    with conn, conn.cursor() as cursor:
        cursor.execute(SQL, [receivedPairId, receivedActivityId])
        response = cursor.fetchone()

        try:
            aid = str(response[0])
            owner = str(response[1])
            if (aid is not None and owner is not None):
                json_response = '{"ActivityUpdated": [' + aid + ', ' + owner + ']}'
                send_activity_pair_update(json_response)
                return make_response(json_response, 200)
        except Exception as e:
            return make_response('{"ErrorWhileUpdatingPairId": ' + str(e) + '}', 404)

    print(owner)

    return owner

@socket.on('connected')
def handle_id(data):
    print(data)

@socket.on('event')
def send_activity_pair_update(ownerId):
    print('Sent update to: ' + ownerId)
    send(ownerId, broadcast=True, namespace="")

@socket.on('message')
def send_new_event(activity):
    print('Sent activity: ' + activity)
    send(activity, broadcast=True, namespace="")


# @socket.on('message')
# def send_updated_activity(activity):