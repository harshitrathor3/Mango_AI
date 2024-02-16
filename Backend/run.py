from flask import Flask
from flask_restx import Api
from flask_cors import CORS
from core_apis.view import api





def create_app(api):
    app = Flask(__name__)
    CORS(app)


    from core_apis.view import mango_ai
    app.register_blueprint(mango_ai)

    api.init_app(app)

    from core_apis.view import mangons
    api.add_namespace(mangons)

    return app





app = create_app(api)


if __name__=='__main__':
    app.run("0.0.0.0", port=5003, debug=True, use_reloader=True)