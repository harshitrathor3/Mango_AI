from flask import Flask, Blueprint, Response, request, jsonify, make_response
from flask_restx import Api, Resource, fields, reqparse
from core_apis.payloads import *




api = Api()


mango_ai = Blueprint('mango', __name__, url_prefix='/mango')
mango_api = Api(mango_ai, version="1.0", title="mango", description="Mango AI Virtual Assistant")
mangons = mango_api.namespace('mango', description='Mango AI Virtual Assistant')

nested_model = api.model('NestedModel', {
    'nested_field': fields.String(description='Nested Field'),
})
main_model = api.model('MainModel', {
    'field1':  fields.String(description='Field 1'),
    'nested': fields.Nested(nested_model),
})




@mangons.route('/my_route')
class MyRoute(Resource):
    @api.expect(my_route, validate=True)
    def get(self):
        try:
            args = my_route.parse_args()
            a = args['arg1']
            b = args['arg2']
            c = args['arg3']
            print(a, b, c, sep='\n\n')
            return "Jai Siya Ram"
        except Exception as e:
            print('Error in My Route : ', e)


@mangons.route('/my_route1')
class MyRoute1(Resource):
    # @api.expect(my_route, validate=True)
    def post(self):
        try:
            args = my_route.parse_args()
            a = args['arg1']
            b = args['arg2']
            c = args['arg3']
            print(a, b, c, sep='\n\n')
            return "Jai Siya Ram"
        except Exception as e:
            print('Error in My Route : ', e)
