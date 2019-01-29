#activate_this = ''
#with open(activate_this) as file:
#	exec(file.read(), dict(__file__=activate_this))

from zenodo.wsgi import application
