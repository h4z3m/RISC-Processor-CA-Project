import os
from assembler import Assembler

def test_assembler():

    test_file_path = os.path.abspath("test.txt")

    # Read the assembly code from the test file
    with open(test_file_path, "r") as f:
        assembly_code = f.read()

    # Assemble the code using the Assembler class
    assembler = Assembler()
    assembler.assemble("test.txt", "test_output.txt")



test_assembler()
