import google.generativeai as genai
from dotenv import load_dotenv
import os

load_dotenv()

genai.configure(api_key=os.getenv('GOOGLE_API_KEY'))


model = genai.GenerativeModel('gemini-pro')
chat = model.start_chat(history=[])

def genrate(prompt):
    response = chat.send_message(prompt)
    return response.text


def chat_model(message, chat_history):
        response = genrate(message)
        chat_history.append((message, response))
        return response, chat_history

prompt = '''who is best cricket player?'''

chat_history = []

# res = chat_model(prompt, chat_history)
# print(res)


# for i in range(10):
#     print('i : ', i)
#     res, hist = chat_model(input(), chat_history)
#     print('res : ', res)
#     print('history : ', chat_history)