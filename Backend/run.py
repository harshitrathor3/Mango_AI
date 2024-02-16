from flask import Flask


app = Flask(__name__)



@app.route('/')
def home():
    return 'server running', 200


@app.route('/route')
def route():
    return 'url running'


if __name__=='__main__':
    app.run(debug=True)