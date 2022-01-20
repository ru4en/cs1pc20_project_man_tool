from flask import Flask, send_from_directory
from flask import render_template
import sys
import json
import os

static_url = os.path.join('static', sys.argv[2])

app = Flask(__name__, static_url_path=static_url)
pmd = sys.argv[1]
with open(pmd) as json_file:
    pm_app = json.load(json_file)

@app.route('/')
def hello_world():
    return render_template('dashboard.html', app_name=pm_app["Project_Name"], authors=pm_app["Author(s)"], git_repo=pm_app["Git_Repo"], file_root=pm_app["File_Root"], users=pm_app["users"], features=pm_app["features"], tests=pm_app["tests"] )

@app.route('/uploads/<path:filename>')
def pm_static_files(filename):
    return send_from_directory(static_url, filename, as_attachment=True)

if __name__ == '__main__':
    app.run()