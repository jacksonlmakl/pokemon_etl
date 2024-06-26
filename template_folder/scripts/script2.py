# script2.py
def script2():
    print("Executing Script 2")
    # Create or open a text file named hello_world.txt in write mode
    with open('hello_world2.txt', 'w') as file:
        # Write the string "Hello World" to the file
        file.write("Hello World")

    print("File has been created and written to successfully.")

script2()
