# MIPS Assembler

This is a Python assembler developed for the Compiler class. It is designed to read a `.txt` file containing MIPS assembly source code and convert it into a `.txt` file with machine code.

The MIPS used here was a modified version created by me in the class "Laboratório de Arquitetura e Organização de Computadores". It is simpler and has less instructions than the original version.

## Usage

1. Make sure you have Python installed on your system.

2. Run the assembler by executing the following command in your terminal:

    ```bash
    python assembler.py -i <input_file> -o <output_file>
    ```

    or simply:

    ```bash
    python assembler.py <input_file> <output_file>
    ```

    where `<input_file>` is the path to the file containing the MIPS assembly source code and `<output_file>` is the path to the file where the machine code will be written.

    If no input file is specified, the assembler will look for a file named `input.txt` in the same directory as the assembler. If no output file is specified, the assembler will write the machine code to a file named `output.txt` in the same directory as the assembler.

3. The machine code will be written to the output file in binary format. Each line will contain a 32-bit instruction.

## Instruction Set

The instruction set is composed of 16 instructions, each with a different opcode. The instructions are divided into 3 types: R, I and J. The following table shows the instructions and their opcodes:

| Instruction | Opcode | Type | Description |
| ----------- | ------ | ---- | ----------- |
| `add` | `0000` | R | Adds two registers and stores the result in a register. |

