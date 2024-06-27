from flask import Flask, render_template, request, redirect, url_for, flash
import subprocess

app = Flask(__name__)
app.secret_key = 'supersecretkey'

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/run_script', methods=['POST'])
def run_script():
    script = request.form['script']
    dag_name = request.form.get('dag_name', '')

    if script == 'create_dag' and not dag_name:
        flash('DAG Name is required for creating DAG.')
        return redirect(url_for('index'))

    try:
        if script == 'create_dag':
            command = ['./create_dag.sh', dag_name]
        else:
            command = ['./' + script + '.sh']
        
        result = subprocess.run(command, capture_output=True, text=True)
        flash(result.stdout)
        if result.stderr:
            flash(result.stderr)
    except Exception as e:
        flash(str(e))

    return redirect(url_for('index'))

@app.route('/docker_ps')
def docker_ps():
    try:
        result = subprocess.run(['sudo', 'docker', 'ps', '-a'], capture_output=True, text=True)
        output = result.stdout
        if result.stderr:
            output += result.stderr
    except Exception as e:
        output = str(e)

    return render_template('output.html', output=output)

@app.route('/docker_logs', methods=['POST'])
def docker_logs():
    container_id = request.form['container_id']
    try:
        result = subprocess.run(['sudo', 'docker', 'logs', container_id], capture_output=True, text=True)
        output = result.stdout
        if result.stderr:
            output += result.stderr
    except Exception as e:
        output = str(e)

    return render_template('output.html', output=output)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8081, debug=True)

# from flask import Flask, render_template, request, redirect, url_for, flash
# import subprocess
# import os

# app = Flask(__name__)
# app.secret_key = 'supersecretkey'

# @app.route('/')
# def index():
#     return render_template('index.html')

# @app.route('/run_script', methods=['POST'])
# def run_script():
#     script = request.form['script']
#     dag_name = request.form.get('dag_name', '')

#     if script == 'create_dag' and not dag_name:
#         flash('DAG Name is required for creating DAG.')
#         return redirect(url_for('index'))

#     try:
#         if script == 'create_dag':
#             command = ['./create_dag.sh', dag_name]
#         else:
#             command = ['./' + script + '.sh']
        
#         result = subprocess.run(command, capture_output=True, text=True)
#         flash(result.stdout)
#         if result.stderr:
#             flash(result.stderr)
#     except Exception as e:
#         flash(str(e))

#     return redirect(url_for('index'))

# if __name__ == '__main__':
#     app.run(host='0.0.0.0', port=8081, debug=True)
