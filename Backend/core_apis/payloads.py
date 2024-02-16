from flask_restx import reqparse





# MyRoute
my_route = reqparse.RequestParser()
my_route.add_argument('arg1', type=int, help='Argument 1', required=True)
my_route.add_argument('arg2', type=str, help='Argument 1', required=True)
my_route.add_argument('arg3', type=str, help='Argument 1')



