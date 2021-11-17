import activity
import secret
import psycopg2
from app import app
from flask import request, make_response

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.args.get('email') is None or request.args.get('password') is None:
        return make_response('{"Bad Request": "Check URL"}', 400)
    emailReceived = format(request.args.get('email'))
    passwordReceived = format(request.args.get('password'))
    uid = ""

    conn = psycopg2.connect(dbname='coredb', user='postgres', host='localhost', password=secret.getDbPass())
    cursor = conn.cursor()
    cursor.execute(
        "SELECT * FROM \"user\" WHERE email=\'{" + emailReceived + "}\' AND password=\'{" + secret.hashText(
            passwordReceived) + "}\';")
    data = cursor.fetchone()
    # print(data)
    try:
        dbEmail = str(data[3][0])
        dbPassword = str(data[5][0])
        if (dbEmail == emailReceived and dbPassword == secret.hashText(passwordReceived)):
            # print(data)
            userData = '{"uid":"' + str(data[0]) + '", "first_name":"' + data[1][0] + '", "last_name":"' + data[2][
                0] + '", "email":"' + data[3][0] + '", "username":"' + data[4][0] + '"}'
            return make_response(userData, 200)

    except Exception as e:
        return make_response('{"UserExists": "false"}', 404)

    conn.close()

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.args.get('fname') is None or request.args.get('lname') is None or \
            request.args.get('uname') is None or request.args.get('email') is None or \
            request.args.get('password') is None:
        return make_response('{"Bad Request": "Check URL"}', 400)

    fnameReceived = "{" + format(request.args.get('fname')) + "}"
    lnameReceived = "{" + format(request.args.get('lname')) + "}"
    emailReceived = "{" + format(request.args.get('email')) + "}"
    unameReceived = "{" + format(request.args.get('uname')) + "}"
    passwordReceived = format(request.args.get('password'))

    conn = psycopg2.connect(dbname='coredb', user='postgres', host='localhost', password=secret.getDbPass())
    cur = conn.cursor()
    # conn.autocommit = True

    emailQuery = "SELECT * FROM \"user\" WHERE email=\'" + emailReceived + "\';"

    # print(emailReceived)

    cur.execute(emailQuery)
    sameEmailsList = cur.fetchall()
    # print(sameEmailsList)
    if sameEmailsList is not None and len(sameEmailsList) > 0:
        return make_response('{"UserEmailAlreadyExists": "true"}', 409)

    usernameQuery = "SELECT * FROM \"user\" WHERE username=\'" + unameReceived + "\';"

    cur.execute(usernameQuery)
    sameUsernamesList = cur.fetchall()
    # print(sameUsernamesList)
    if sameUsernamesList is not None and len(sameUsernamesList) > 0:
        return make_response('{"UsernameAlreadyExists": "true"}', 410)

    signUpInsert = "INSERT INTO \"user\" (first_name, last_name, email, username,  password) VALUES (%s, %s, %s, %s, %s);"

    data = (fnameReceived, lnameReceived, emailReceived, unameReceived, '{' + secret.hashText(passwordReceived) + '}')
    with conn, conn.cursor() as cur:
        cur.execute(signUpInsert, data)

    # print(cur.statusmessage)
    conn.close()
    try:
        if str(cur.statusmessage) == "INSERT 0 1":
            return make_response('{"UserCreated": "true"}', 200)

    except Exception as e:
        print("here")
        return make_response('{"UserCreated": "false"} ' + str(e), 404)

@app.route('/getuser', methods=['GET', 'POST'])
def getUser():
    if request.args.get('uid') is None:
        return make_response('{"Bad Request": "Check URL"}', 400)

    uidReceived = request.args.get('uid')
    print(uidReceived)

    conn = psycopg2.connect(dbname='coredb', user='postgres', host='localhost', password=secret.getDbPass())

    SQL = "SELECT * FROM \"user\" WHERE uid=%s;"

    cursor = conn.cursor()

    cursor.execute(SQL, [uidReceived])
    print(cursor.statusmessage)

    try:
        if str(cursor.statusmessage) is not "None":
            data = cursor.fetchone()
            userData = '{"uid":"' + str(data[0]) + '", "first_name":"' + data[1][0] + '", "last_name":"' + data[2][
                0] + '", "email":"' + data[3][0] + '", "username":"' + data[4][0] + '"}'

            return make_response(userData, 200)
    except Exception as e:
        return make_response('{"UserRetrieved": "false"}', 404)

    conn.close()