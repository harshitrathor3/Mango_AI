from flask import Flask, Blueprint, Response, request, jsonify, make_response
from flask_restx import Api, Resource, fields, reqparse
from core_apis.payloads import *

import json


from core_apis.control import *




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
        

@mangons.route('/talktome/teacher')
class TTMteacher(Resource):
    # @api.expect(ttm_teacher, validate=True)
    def post(self):
        try:
            json_data = request.get_json()
            
            user_id = json_data['user_id']
            question = json_data['question']
            chat_history = json_data['chat_history']
            name = json_data['name']
            age = json_data['age']
            gender = json_data['gender']
            
            answer, chat_history = ttm_teacher(user_id, question, chat_history, name, age, gender)

            data = {'answer': answer, 'chat_history': chat_history, 'user_id': user_id}

            return data, 200
        except Exception as e:
            print('Error in TTM Teacher : ', e)
            return f'Error occured in my TTM Teacher : {e}', 500


@mangons.route('/talktome/option')
class TTMoption(Resource):
    # @api.expect(ttm_option, validate=True)
    def post(self):
        try:
            json_data = request.get_json()
            
            option = json_data['option']
            user_id = json_data['user_id']
            question = json_data['question']
            chat_history = json_data['chat_history']
            name = json_data['name']
            age = json_data['age']
            gender = json_data['gender']
            # provide with some prompt so that the AI chat bot will Act as carrier counsellor and provide useful solutions for different carrier related problems
            answer, chat_history = ttm_option(option, user_id, question, chat_history, name, age, gender)

            data = {'answer': answer, 'chat_history': chat_history, 'user_id': user_id}
            
            return data, 200
        except Exception as e:
            print('Error in TTM Option : ', e)
            return f'Error occured in my TTM Option : {e}', 500



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
        


@mangons.route('/gmail/summary')
class GmailSummary(Resource):
    # @api.expect(gmail_summary, validate=True)
    def post(self):
        try:
            json_data = request.get_json()
            response_json = gmail_summary(json_data)
            data = json.loads(response_json)
            # print(data)
            return data, 200
            # return response_json, 200
        except Exception as e:
            print('Error in GmailSummary : ', e)
            return f'Error occured in GmailSummary{e}', 500