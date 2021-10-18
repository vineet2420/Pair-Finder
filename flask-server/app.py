from flask import Flask, request, jsonify, make_response, json
import secret
import psycopg2
import hashlib

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"

def hashText(clearText):
    salt = secret.getSalt()
    clearText = clearText.encode()

    # Iterate hash for text 200k times
    hashVal = hashlib.pbkdf2_hmac('sha256', clearText, salt, 200000)
    return hashVal.hex()

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.args.get('email') is None or request.args.get('password') is None:
        return make_response('{"Bad Request": "Check URL"}', 400)
    emailReceived = format(request.args.get('email'))
    passwordReceived = format(request.args.get('password'))

    random_var = psycopg2.connect(dbname='CoreDB', user='postgres', host='localhost', password=secret.getDbPass())
    new_var = random_var.cursor()
    new_var.execute(
        "SELECT email, password FROM \"user\" WHERE email=\'{" + emailReceived + "}\' AND password=\'{" + hashText(passwordReceived) + "}\';")
    items = new_var.fetchall()

    random_var.close()
    try:
        dbEmail = str(items[0][0][0])
        dbPassword = str(items[0][1][0])
        if (dbEmail == emailReceived and dbPassword == hashText(passwordReceived)):
            return make_response('{"UserExists": "true"}', 200)

    except Exception as e:
        return make_response('{"UserExists": "false"}', 404)

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.args.get('fname') is None or request.args.get('lname') is None or \
            request.args.get('uname') is None or request.args.get('email') is None or \
            request.args.get('password') is None:
        return make_response('{"Bad Request": "Check URL"}', 400)

    fnameReceived = "{" + format(request.args.get('fname')) + "}"
    lnameReceived = "{" + format(request.args.get('lname')) + "}"
    unameReceived = "{" + format(request.args.get('uname')) + "}"
    emailReceived = "{" + format(request.args.get('email')) + "}"
    passwordReceived = format(request.args.get('password'))

    conn = psycopg2.connect(dbname='CoreDB', user='postgres', host='localhost', password=secret.getDbPass())
    cur = conn.cursor()
    # conn.autocommit = True

    SQL = "INSERT INTO \"user\" (first_name, last_name, email, username,  password) VALUES (%s, %s, %s, %s, %s);"

    data = (fnameReceived, lnameReceived, emailReceived, unameReceived, '{'+hashText(passwordReceived)+'}')
    with conn, conn.cursor() as cur:
        cur.execute(SQL, data)

    print(cur.statusmessage)
    conn.close()
    try:
        if str(cur.statusmessage) == "INSERT 0 1":
            return make_response('{"UserCreated": "true"}', 200)

    except Exception as e:
        return make_response('{"UserCreated": "false"}', 404)


app.run(debug=True)
