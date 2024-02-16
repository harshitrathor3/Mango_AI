from flask_restx import reqparse




# Server Test
server_test = reqparse.RequestParser()
server_test.add_argument('arg', type=str, help='Argument')





# TTM Friend
ttm_friend = reqparse.RequestParser()
ttm_friend.add_argument('user_id', type=int, help='User ID', required=True)
ttm_friend.add_argument('question', type=str, help='User Question', required=True)
ttm_friend.add_argument('chat_history', type=list, help='Chat History', required=True, location='json')





# MyRoute
my_route = reqparse.RequestParser()
my_route.add_argument('arg1', type=int, help='Argument 1', required=True)
my_route.add_argument('arg2', type=str, help='Argument 1', required=True)
my_route.add_argument('arg3', type=str, help='Argument 1')




# Rachit
rachit = reqparse.RequestParser()
rachit.add_argument('a', type=str, help='this is a', required=True)
rachit.add_argument('b', type=str, help='this is b', required=True)
