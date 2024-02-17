from flask import Flask, Blueprint, Response, request, jsonify, make_response
from flask_restx import Api, Resource, fields, reqparse
from core_apis.payloads import *

import json

from core_apis.control import QNA, ttm_friend, gmail_autowriting



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
            return f'Error occured in my route : {e}', 500


@mangons.route('/talktome/friend')
class TTMfriend(Resource):
    # @api.expect(ttm_friend, validate=True)
    def post(self):
        try:
            json_data = request.get_json()
            
            user_id = json_data['user_id']
            question = json_data['question']
            chat_history = json_data['chat_history']
            name = json_data['name']
            age = json_data['age']
            
            answer, chat_history = ttm_friend(user_id, question, chat_history, name, age)

            data = {'answer': answer, 'chat_history': chat_history, 'user_id': user_id}
            return data, 200
        except Exception as e:
            print('Error in TTM Friend : ', e)
            return f'Error occured in my TTM friend : {e}', 500
        


@mangons.route('/qna')
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
            print('Error in QNA : ', e)
            return f'Error occured in QueNanS : {e}', 500
        

@mangons.route('/gmail/autowriting')
class GmailAutoWriting(Resource):
    # @api.expect(qna_ai, validate=True)
    def post(self):
        try:
            json_data = request.get_json()
            user_id = json_data['user_id']
            mail_subject = json_data['mail_subject']
            gmail_token = json_data['gmail_token']

            # print(json_data)
            mails = gmail_autowriting(mail_subject)
            # print(mails)
            # mails = eval(mails)
            # print(mails)
            # print(type(mails))
            
            return mails
        except Exception as e:
            print('Error in Gmail autowriting', e)
            return f'Error in gmail autowriting : {e}'