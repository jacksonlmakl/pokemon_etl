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
    image_name = request.form.get('image_name', 'jacksonmakl/data_flow_tool')
    image_version = request.form.get('image_version', 'latest')
    container_name = request.form.get('container_name', 'airflow_container')

    if script == 'create_dag' and not dag_name:
        flash('DAG Name is required for creating DAG.')
        return redirect(url_for('index'))

    try:
        if script == 'create_dag':
            command = ['./create_dag.sh', dag_name]
        elif script == 'docker_image':
            command = ['./docker_image.sh', image_name, image_version, container_name]
        elif script == 'docker_start':
            command = ['./docker_start.sh', container_name, image_name, image_version]
        elif script == 'docker_stop':
            command = ['./docker_stop.sh', container_name]
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

@app.route('/docker_images')
def docker_images():
    try:
        result = subprocess.run(['sudo', 'docker', 'images'], capture_output=True, text=True)
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

@app.route('/docker_login', methods=['POST'])
def docker_login():
    username = request.form['username']
    password = request.form['password']
    try:
        result = subprocess.run(['sudo', 'docker', 'login', '--username', username, '--password-stdin'], input=password, capture_output=True, text=True)
        output = result.stdout
        if result.stderr:
            output += result.stderr
    except Exception as e:
        output = str(e)
        
    return render_template('output.html', output=output)

@app.route('/docker_push', methods=['POST'])
def docker_push():
    image_name = request.form['image_name']
    try:
        result = subprocess.run(['sudo', 'docker', 'push', image_name], capture_output=True, text=True)
        output = result.stdout
        if result.stderr:
            output += result.stderr
    except Exception as e:
        output = str(e)
        
    return render_template('output.html', output=output)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8081, debug=True)
