import hashlib

def getSalt():
    return b'\xf4pJw\xacV\x8d\xdd\xf6T< \xdb\xe6\xf6\xd5\x96\xbe\x05\x82\xa7\x82A\xd4\xb3\xcf\x92\x1e\x92t\x00\xa2'

def getDbPass():
    return 'YOUR_PASSWORD'

def hashText(clearText):
    salt = getSalt()
    clearText = clearText.encode()

    # Iterate hash for text 200k times
    hashVal = hashlib.pbkdf2_hmac('sha256', clearText, salt, 200000)

    return hashVal.hex()
