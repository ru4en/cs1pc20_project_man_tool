from flask import Flask
from flask import render_template

import sys
import json

app = Flask(__name__)
pmd = sys.argv[1]
with open(pmd) as json_file:
    pm_app = json.load(json_file)

@app.route('/')
def hello_world():
    return render_template('dashboard.html', app_name=pm_app["Project Name"], authors=pm_app["Author(s)"], git_repo=pm_app["Git Repo"], treeuml=pm_app["tree"])

if __name__ == '__main__':
    app.run()