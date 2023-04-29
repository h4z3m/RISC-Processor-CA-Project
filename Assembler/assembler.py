import argparse


class Assembler:
    register_indices = {
        "R0": "000",
        "R1": "001",
        "R2": "010",
        "R3": "011",
        "R4": "100",
        "R5": "101",
        "R6": "110",
        "R7": "111",
    }

    ALU_funct = {
        "NOP": "000",
        "AND": "001",
        "OR": "010",
        "NOT": "011",
        "ADD": "100",
        "SUB": "101",
        "DEC": "110",
        "INC": "111",
    }

    opcodes = {
        # I-type
        "IN": "001001",
        "OUT": "000100",
        "LDM": "001000",
        "IADD": "001010",
        "LDD": "001110",
        "STD": "000011",
        "PUSH": "000010",
        "POP": "001100",
        "NOP": "000000",
        "SETC": "000111",
        "CLRC": "000110",
        # R-type
        "NOT": "011011",
        "INC": "011111",
        "DEC": "011110",
        "MOV": "010000",
        "ADD": "011100",
        "SUB": "011101",
        "AND": "011001",
        "OR": "011010",
        # J-type
        "JZ": "100000",
        "JC": "100100",
        "JMP": "101000",
        "CALL": "101010",
        "RET": "101100",
        "RTI": "101101",
        #Ohters
        "INT": "101011",
        "RESET": "110000",
    }
        
    def assemble(self, inputFilename: str, outputFilename: str , binary: bool, hexadecimal: bool):
        """Assemble instructions from input file and write binary code to output file

        Args:
            inputFilename (str): Input file name
            outputFilename (str): Output file name
        """
        with open(inputFilename, 'r') as f:
            instructions = f.readlines()
        bin_instructions = {}
        current_line = 0
        max_line = 0
        for inst in instructions:
            binary_inst, flag = self.getOpcode(inst)
            if flag == False:
                # print(binary_inst)
                if binary_inst is None:
                    raise ValueError(f"Invalid instruction: {inst}")
                if len(binary_inst) == 32:
                    bin_instructions[current_line] = binary_inst[16:32]
                    bin_instructions[current_line + 1] = binary_inst[0:16]
                    current_line += 2
                else:
                    bin_instructions[current_line] = binary_inst
                    current_line += 1
            else:
                current_line = binary_inst
            if current_line > max_line:
                max_line = current_line

        with open(outputFilename, 'w') as f:
            f.write("// memory data file (do not edit the following line - required for mem load use)\n")
            f.write("// instance=/risc_cpu/Instruction_Memory/ram\n")
            f.write("// format=mti addressradix=h dataradix=")
            if binary: f.write("b")
            else: f.write("h")
            f.write(" version=1.0 wordsperline=1\n")
            for i in range(max_line):
                f.write(str(hex(i)[2:])+ ": ")
                if i in bin_instructions:
                    if hexadecimal:
                        f.write(hex(int(bin_instructions[i], 2))[2:].zfill(4) + "\n")
                    else:
                        f.write(bin_instructions[i] + "\n")
                else:
                    if hexadecimal:
                        f.write("0000\n")
                    else:
                        f.write("0000000000000000\n")

    def getOpcode(self, instruction: str):
        """Determine the opcode for a given instruction based on its syntax.

        Args:
            instruction (str): Instruction to be assembled

        Returns:
            str: Opcode in binary or None if instruction is invalid
        """
        inst_parts = instruction.strip().split()
        #capatilize all parts
        inst_parts = [part.upper() for part in inst_parts]
        #remove last comma if present
        for i, part in enumerate(inst_parts):
            if part.endswith(","):  # Check if part ends with a comma
                if part[:-1] in Assembler.register_indices:  # Check if part without comma is a register name
                    inst_parts[i] = part[:-1]  # Remove the comma

        opcode = None
        # print(inst_parts[0])
        if inst_parts[0] in self.opcodes:
            opcode = self.opcodes[inst_parts[0]]
            if inst_parts[0] == "NOT" or inst_parts[0] == "INC" or inst_parts[0] == "DEC" or inst_parts[0] == "MOV":
                opcode += self.register_indices[inst_parts[2]] + "000" + self.register_indices[inst_parts[1]] + "0"
            elif inst_parts[0] == "ADD" or inst_parts[0] == "SUB" or inst_parts[0] == "AND" or inst_parts[0] == "OR":
                opcode += self.register_indices[inst_parts[2]] + self.register_indices[inst_parts[3]] + self.register_indices[inst_parts[1]] + "0"             
            elif inst_parts[0] == "IN":
                opcode += "000" + self.register_indices[inst_parts[1]] + "0000"
            elif inst_parts[0] == "OUT":
                opcode += self.register_indices[inst_parts[1]] + "0000000"
            elif inst_parts[0] == "IADD":
                opcode += self.register_indices[inst_parts[2]] + self.register_indices[inst_parts[1]] + "0000" + bin(int(inst_parts[3], 16))[2:].zfill(len(inst_parts[3])*4)
            elif inst_parts[0] == "LDM":
                opcode += "000" + self.register_indices[inst_parts[1]] + "0000" + bin(int(inst_parts[2], 16))[2:].zfill(len(inst_parts[2])*4)
            elif inst_parts[0] == "LDD":
                opcode += self.register_indices[inst_parts[2]] + self.register_indices[inst_parts[1]] + "0000"
            elif inst_parts[0] == "STD":
                opcode += self.register_indices[inst_parts[1]] + self.register_indices[inst_parts[2]] + "0000"
            elif inst_parts[0] == "PUSH" or inst_parts[0] == "POP":
                opcode += "000" + self.register_indices[inst_parts[1]] + "0000"
            elif inst_parts[0] == "JZ" or inst_parts[0] == "JC" or inst_parts[0] == "JMP" or inst_parts[0] == "CALL":
                opcode += self.register_indices[inst_parts[1]] + "0000000"
            elif inst_parts[0] == "RET" or inst_parts[0] == "RTI" or inst_parts[0] == "INT" or inst_parts[0] == "RESET":
                opcode += "0000000000"
            elif inst_parts[0] == "NOP" or inst_parts[0] == "SETC" or inst_parts[0] == "CLRC":
                opcode = opcode + "0000000000"
            return opcode, 0
            
        elif inst_parts[0] == ".ORG":
                current_line = int(inst_parts[1])
                return current_line, 1 
        else:
                opcode = bin(int(inst_parts[0], 16))[2:].zfill(16)
                return opcode, 0
