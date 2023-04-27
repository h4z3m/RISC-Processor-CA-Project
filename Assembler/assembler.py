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
        "NOT": "",
        "INC": "",
        "DEC": "",
        "ADD": "",
        "SUB": "",
        "AND": "",
        "OR": "",
        "MOV": "",
        # J-type
        "JZ": "",
        "JC": "",
        "JMP": "",
        "CALL": "",
        "RET": "",
        "RTI": "",
    }

    def assemble(self, inputFilename: str, outputFilename: str):
        pass
