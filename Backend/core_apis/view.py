from flask import Flask, Blueprint, Response, request, jsonify, make_response
from flask_restx import Api, Resource, fields, reqparse
from core_apis.payloads import *

import json

from AI.ai_model import chat_model
from core_apis.control import QNA


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


@mangons.route('/server_test')
class ServerTest(Resource):
    @api.expect(server_test, validate=True)
    def get(self):
        try:
            args = server_test.parse_args()
            val = args['arg']
            print(val)
            return 'server running', 200
        except Exception as e:
            print('Error in server test : ', e)
            return f'Error occured in my route{e}', 500


@mangons.route('/talktome/friend')
class TTMfriend(Resource):
    # @api.expect(ttm_friend, validate=True)
    def post(self):
        try:
            json_data = request.get_json()
            
            user_id = json_data['user_id']
            question = json_data['question']
            chat_history = json_data['chat_history']
            
            answer = 'this is my answer'

            data = {'answer': answer, 'chat_history': chat_history, 'user_id': user_id}
            return data, 200
        except Exception as e:
            print('Error in TTM Friend : ', e)
            return f'Error occured in my TTM friend : {e}', 500
        


@mangons.route('/qna_ai')
class QueNanS(Resource):
    # @api.expect(qna_ai, validate=True)
    def post(self):
        try:
            json_data = request.get_json()
            user_id = json_data['user_id']
            question = json_data['question']
            chat_history = json_data['chat_history']

            answer, chat_history = QNA(user_id, question, chat_history)

            data = {"user_id" : user_id, "answer" : answer, "chat_history" : chat_history}

            return data, 200
        except Exception as e:
            print('Error in server test : ', e)
            return f'Error occured in QueNanS{e}', 500