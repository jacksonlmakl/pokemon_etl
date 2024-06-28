from flask import Flask, render_template, request, redirect, url_for, flash
import subprocess
import os

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

@app.route('/github_push', methods=['POST'])
def github_push():
    repo_url = request.form['repo_url']
    branch_name = request.form['branch_name']
    try:
        # Ensure git user configuration is set
        subprocess.run(['git', 'config', '--global', 'user.email', 'you@example.com'], check=True)
        subprocess.run(['git', 'config', '--global', 'user.name', 'Your Name'], check=True)
        
        # Initialize git repository if not already initialized
        subprocess.run(['git', 'init'], check=True)
        
        # Check if remote origin already exists
        result = subprocess.run(['git', 'remote'], capture_output=True, text=True)
        if 'origin' in result.stdout:
            subprocess.run(['git', 'remote', 'remove', 'origin'], check=True)
        
        # Add remote origin
        subprocess.run(['git', 'remote', 'add', 'origin', repo_url], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        
        # Add files, commit, and push to GitHub
        subprocess.run(['git', 'add', '.'], check=True)
        subprocess.run(['git', 'commit', '-m', 'Initial commit'], check=True)
        result = subprocess.run(['git', 'push', '--set-upstream', 'origin', branch_name], capture_output=True, text=True)
        
        flash(result.stdout)
        if result.stderr:
            flash(result.stderr)
    except subprocess.CalledProcessError as e:
        flash(f"An error occurred: {e}")
    
    return redirect(url_for('index'))


@app.route('/create_ssh_key', methods=['POST'])
def create_ssh_key():
    ssh_key_email = request.form['ssh_key_email']
    ssh_key_path = os.path.expanduser('~/.ssh/id_rsa')
    
    # Remove existing SSH key files
    try:
        if os.path.exists(ssh_key_path):
            os.remove(ssh_key_path)
            os.remove(f'{ssh_key_path}.pub')
    except Exception as e:
        flash(f"Error removing existing SSH key: {str(e)}")
        return redirect(url_for('index'))
    
    # Create new SSH key
    try:
        result = subprocess.run(
            ['ssh-keygen', '-t', 'rsa', '-b', '4096', '-C', ssh_key_email, '-f', ssh_key_path, '-N', ''],
            capture_output=True, text=True
        )
        if result.stderr:
            flash(result.stderr)
        else:
            flash('SSH key created successfully.')
    except Exception as e:
        flash(f"Error creating SSH key: {str(e)}")

    return redirect(url_for('index'))

@app.route('/view_ssh_key', methods=['GET'])
def view_ssh_key():
    try:
        with open(os.path.expanduser('~/.ssh/id_rsa.pub'), 'r') as file:
            ssh_key = file.read()
        flash(ssh_key)
    except Exception as e:
        flash(str(e))
    
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8081, debug=True)