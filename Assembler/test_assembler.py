import os
import argparse
from assembler import Assembler


#parse arguments for input filename, output filename, and output format in binary and hexadecimal
parser = argparse.ArgumentParser(description="Assembler for the LC-3b ISA")
parser.add_argument("input", help="Input file name")
parser.add_argument("output", help="Output file name")
parser.add_argument("-b", "--binary", action="store_true", help="Output in binary format")
parser.add_argument("-x", "--hexadecimal", action="store_true", help="Output in hexadecimal format")
args = parser.parse_args()
#extract input and output filenames
input_filename = args.input
output_filename = args.output
assembler = Assembler()
assembler.assemble(input_filename, output_filename, args.binary, args.hexadecimal)
