import google.generativeai as genai
from AI.constants import GOOGLE_API_KEY


genai.configure(api_key=GOOGLE_API_KEY)


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