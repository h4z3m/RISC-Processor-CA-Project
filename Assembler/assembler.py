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
        "NOT": "011000",
        "INC": "011000",
        "DEC": "011000",
        "MOV": "010000",
        "ADD": "011000",
        "SUB": "011000",
        "AND": "011000",
        "OR": "011000",
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
    func = {
        # I-type
        "IN": "",
        "OUT": "",
        "LDM": "",
        "IADD": "",
        "LDD": "",
        "STD": "",
        "PUSH": "",
        "POP": "",
        "NOP": "",
        "SETC": "",
        "CLRC": "",
        # R-type
        "NOT": "011",
        "INC": "111",
        "DEC": "110",
        "MOV": "000",
        "ADD": "100",
        "SUB": "101",
        "AND": "001",
        "OR": "010",
        # J-type
        "JZ": "000",
        "JC": "001",
        "JMP": "000",
        "CALL": "000",
        "RET": "101100",
        "RTI": "101101",
        #Ohters
        "INT": "101011",
        "RESET": "110000",
    }
        
    def assemble(self, inputFilename: str, outputFilename: str):
        """Assemble instructions from input file and write binary code to output file

        Args:
            inputFilename (str): Input file name
            outputFilename (str): Output file name
        """
        with open(inputFilename, 'r') as f:
            instructions = f.readlines()
        binary_instructions = []
        for inst in instructions:
            binary_inst = self.getOpcode(inst)
            if binary_inst is None:
                raise ValueError(f"Invalid instruction: {inst}")
            binary_instructions.append(binary_inst)

        with open(outputFilename, 'w') as f:
            f.write("\n".join(binary_instructions))

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
        print(inst_parts)
        if inst_parts[0] in self.opcodes:
            opcode = self.opcodes[inst_parts[0]]
            if opcode.startswith("0"):  # I-type instruction
                if inst_parts[0] == "NOT" or inst_parts[0] == "INC" or inst_parts[0] == "DEC" or inst_parts[0] == "MOV":
                    opcode += self.register_indices[inst_parts[2]] + "000" + self.register_indices[inst_parts[1]] + self.func[inst_parts[0]]
                elif inst_parts[0] == "ADD" or inst_parts[0] == "SUB" or inst_parts[0] == "AND" or inst_parts[0] == "OR":
                    opcode += self.register_indices[inst_parts[2]] + self.register_indices[inst_parts[3]] + self.register_indices[inst_parts[1]] + self.func[inst_parts[0]]               
                elif inst_parts[0] == "IN":
                    opcode += "000" + self.register_indices[inst_parts[1]] + "000000"
                elif inst_parts[0] == "OUT":
                    opcode += self.register_indices[inst_parts[1]] + "000000000"
                elif inst_parts[0] == "IADD":
                    opcode += self.register_indices[inst_parts[2]] + self.register_indices[inst_parts[1]] + "0000" + inst_parts[3]
                elif inst_parts[0] == "LDM":
                    opcode += "000" + self.register_indices[inst_parts[1]] + "0000" + inst_parts[2]
                elif inst_parts[0] == "LDD":
                    opcode += self.register_indices[inst_parts[2]] + self.register_indices[inst_parts[1]] + "000000"
                elif inst_parts[0] == "STD":
                    opcode += self.register_indices[inst_parts[1]] + self.register_indices[inst_parts[2]] + "000000"
                elif inst_parts[0] == "PUSH" or inst_parts[0] == "POP":
                    opcode += "000000" + self.register_indices[inst_parts[1]] + "000000"
                elif inst_parts[0] == "JZ" or inst_parts[0] == "JC" or inst_parts[0] == "JMP" or inst_parts[0] == "CALL":
                    opcode += self.register_indices[inst_parts[1]] + "000000" + self.func[inst_parts[0]]
                elif inst_parts[0] == "RET" or inst_parts[0] == "RTI" or inst_parts[0] == "INT" or inst_parts[0] == "RESET":
                    opcode += "000000000000"
                elif inst_parts[0] == "NOP" or inst_parts[0] == "SETC" or inst_parts[0] == "CLRC":
                    opcode = opcode
                else: # Invalid instruction
                    opcode = None
            if opcode is not None:
                while len(opcode) < 32:
                        opcode += "0"
            print(opcode)

        return opcode
