# script1.py
def script1():
    print("Executing Script 1")
    # Create or open a text file named hello_world.txt in write mode
    with open('hello_world.txt', 'w') as file:
        # Write the string "Hello World" to the file
        file.write("Hello World")

    print("File has been created and written to successfully.")

script1()
