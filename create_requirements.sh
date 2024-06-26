VENV_DIR="airflow_venv"

# Define the output file for the requirements
OUTPUT_FILE="requirements.txt"

# Check if the virtual environment directory exists
if [ ! -d "$VENV_DIR" ]; then
  echo "Virtual environment directory $VENV_DIR does not exist."
  exit 1
fi

# Activate the virtual environment
source "$VENV_DIR/bin/activate"

# Generate the requirements.txt file
pip freeze > "$OUTPUT_FILE"

# Deactivate the virtual environment
deactivate

echo "Requirements have been saved to $OUTPUT_FILE"

# Remove pkg_resources from requirements.txt if present
sed -i "s/pkg_resources==0.0.0/ /g" $OUTPUT_FILE