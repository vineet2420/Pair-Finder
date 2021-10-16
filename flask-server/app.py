from flask import Flask, request, jsonify, make_response, json
import psycopg2

app = Flask(__name__)


@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"


@app.route('/login', methods=['GET', 'POST'])
def login():
    emailReceived = format(request.args.get('email'))
    passwordReceived = format(request.args.get('password'))

    random_var = psycopg2.connect(dbname='CoreDB', user='postgres', host='localhost', password='vinsteradmin123$')
    new_var = random_var.cursor()
    new_var.execute(
        "SELECT email, password FROM \"user\" WHERE email=\'{" + emailReceived + "}\' AND password=\'{" + passwordReceived + "}\';")
    items = new_var.fetchall()

    try:
        dbEmail = str(items[0][0][0])
        dbPassword = str(items[0][1][0])

        if (dbEmail == emailReceived and dbPassword == passwordReceived):
            return make_response('{"UserExists": "true"}', 200)

    except Exception as e:
        return make_response('{"UserExists": "false"}', 404)


@app.route('/signup', methods=['GET', 'POST'])
def signup():
    fnameReceived = "{"+format(request.args.get('fname'))+"}"
    lnameReceived = "{"+format(request.args.get('lname'))+"}"
    unameReceived = "{"+format(request.args.get('uname'))+"}"
    emailReceived = "{"+format(request.args.get('email'))+"}"
    passwordReceived = "{"+format(request.args.get('password'))+"}"

    conn = psycopg2.connect(dbname='CoreDB', user='postgres', host='localhost', password='vinsteradmin123$')
    cur = conn.cursor()
    #conn.autocommit = True

    SQL = "INSERT INTO \"user\" (first_name, last_name, email, username,  password) VALUES (%s, %s, %s, %s, %s);"
    # Note: no quotes
    data = (fnameReceived, lnameReceived, emailReceived, unameReceived, passwordReceived)
    with conn, conn.cursor() as cur:
        cur.execute(SQL, data)  # Note: no % operator


    try:

        return make_response('{"UserCreated": "true"}', 200)

    except Exception as e:
        return make_response('{"UserCreated": "false"}', 404)


app.run(debug=True)
