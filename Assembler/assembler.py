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
        """_summary_

        Args:
            inputFilename (str): _description_
            outputFilename (str): _description_
        """
        pass

    def getOpcode(self, instruction: str):
        """_summary_

        Args:
            instruction (str): _description_
        """
        pass


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="An assembler for a RISC-like processor."
    )
    parser.add_argument(
        "-a",
        "--assemble",
        help="Assembles a given file and outputs assembled bitcode.",
        nargs="*",
    )
    args = parser.parse_args()
    print(args.assemble)
