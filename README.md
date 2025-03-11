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

### Type R

| Instruction | Opcode   | Type | Description                                                                                                  | Usage                       |
| ----------- | -------- | ---- | ------------------------------------------------------------------------------------------------------------ | --------------------------- |
| `add`       | `000000` | R    | Adds two registers and stores the result in a register.                                                      | `add $rd $rs $rt`           |
| `sub`       | `000000` | R    | Subtracts two registers and stores the result in a register.                                                 | `sub $rd $rs $rt`           |
| `and`       | `000000` | R    | Performs a bitwise AND operation on two registers and stores the result in a register.                       | `and $rd $rs $rt`           |
| `or`        | `000000` | R    | Performs a bitwise OR operation on two registers and stores the result in a register.                        | `or $rd $rs $rt`            |
| `nor`       | `000000` | R    | Performs a bitwise NOR operation on two registers and stores the result in a register.                       | `nor $rd $rs $rt`           |
| `xor`       | `000000` | R    | Performs a bitwise XOR operation on two registers and stores the result in a register.                       | `xor $rd $rs $rt`           |
| `slt`       | `000000` | R    | Compares two registers and stores the result in a register.                                                  | `slt $rd $rs $rt`           |
| `sll`       | `000000` | R    | Shifts a register left by a specified amount and stores the result in a register.                            | `Only the compiler can use` |
| `srl`       | `000000` | R    | Shifts a register right by a specified amount and stores the result in a register.                           | `Only the compiler can use` |
| `div`       | `000000` | R    | Divides two registers and stores the result in a register.                                                   | `div $rd $rs $rt`           |
| `mul`       | `000000` | R    | Multiplies two registers and stores the result in a register.                                                | `mult $rd $rs $rt`          |
| `jr`        | `000000` | R    | Jumps to the address stored in a register.                                                                   | `jr $zero $rs $zero`        |
| `jalr`      | `000000` | R    | Jumps to the address stored in a register and stores the address of the next instruction in `$ra` register . | `jalr $rs`                  |
| `nop`       | `000000` | R    | An instruction that does nothing. Can help while making jumps.                                               | `nop`                       |

### Type I

| Instruction | Opcode   | Type | Description                                                                                        | Usage                            |
| ----------- | -------- | ---- | -------------------------------------------------------------------------------------------------- | -------------------------------- |
| `lw`        | `100011` | I    | Loads a word from memory into a register.                                                          | `lw $rt offset($rs)`             |
| `sw`        | `101011` | I    | Stores a word from a register into memory.                                                         | `sw $rt offset($rs)`             |
| `beq`       | `000100` | I    | Branches to a label if two registers are equal.                                                    | `beq $rs $rt label`              |
| `bne`       | `000101` | I    | Branches to a label if two registers are not equal.                                                | `bne $rs $rt label`              |
| `addi`      | `001000` | I    | Adds a register and a constant and stores the result in a register.                                | `addi $rt $rs constant`          |
| `subi`      | `001001` | I    | Subtracts a register and a constant and stores the result in a register.                           | `subi $rt $rs constant`          |
| `andi`      | `001100` | I    | Performs a bitwise AND operation on a register and a constant and stores the result in a register. | `andi $rt $rs constant`          |
| `ori`       | `001101` | I    | Performs a bitwise OR operation on a register and a constant and stores the result in a register.  | `ori $rt $rs constant`           |
| `xori`      | `101101` | I    | Performs a bitwise XOR operation on a register and a constant and stores the result in a register. | `xori $rt $rs constant`          |
| `slti`      | `001010` | I    | Compares a register and a constant and stores the result in a register.                            | `slti $rt $rs constant`          |
| `in`        | `011111` | I    | Reads a word from the input and stores it in a register.                                           | `in $rt $zero 0`                 |
| `out`       | `011110` | I    | Writes a word from a register to the output.                                                       | `out $zero $rs 0`                |
| `disp`      | `111110` | I    | Display the selected message in the LCD display                                                    | `disp $rt $rs numberofmessage`   |
| `pc`        | `100100` | I    | Stores the address of the next instruction in a register.                                          | `pc $rt $zero 0`                 |
| `pci`       | `110100` | I    | Get the PC value that was stored in the interruption buffer                                        | `pci $rt $zero 0`                |
| `clk`       | `000001` | I    | Start a clock counter. It will create a interruption after the number of cycle and jump to PC zero | `clk $zero $zero numberofcycles` |
| `checkint`  | `000110` | I    | Get the type of the interruption raised. 0 if none, 1 if halt and 2 if clock                       | `checkint $rt $zero 0`           |

### Type J

| Instruction | Opcode   | Type | Description                                                                        | Usage       |
| ----------- | -------- | ---- | ---------------------------------------------------------------------------------- | ----------- |
| `j`         | `000010` | J    | Jumps to a label.                                                                  | `j label`   |
| `jal`       | `000011` | J    | Jumps to a label and stores the address of the next instruction in `$ra` register. | `jal label` |
| `halt`      | `111111` | J    | Stops the execution of the program.                                                | `halt`      |

## labels

Labels are used to mark the beginning of a block of code. They are used by the assembler to calculate the offset of branch instructions. Labels must be declared at the beginning of a line, followed by a colon. The following example shows how to declare a label:

```assembly
label:
```

## Comments

Comments are used to document the code. They can be declared at the end of a line or in a separate line. The following example shows how to declare a comment:

```assembly
# This is a comment
add $t0 $t1 $t2 # This is another comment
```

## Defines

Defines are used to declare constants. The directive `%define` is used to declare a constant. The following example shows how to declare a constant:

```assembly
%define constant 10
```

## Registers

The MIPS used here has 32 registers, each 32 bits wide. The following table shows the registers and their numbers:

| Register     | Number   | Usage                         |
| ------------ | -------- | ----------------------------- | ------------------------------------ |
| `$zero`      | `31`     | Constant 0                    |
| `$ra`        | `30`     | Return address                |
| `$fp`        | `29`     | Frame pointer                 |
| `$sp`        | `28`     | Stack pointer                 |
| `$temp`      | `27`     | Temporary                     | # register reserved for the compiler |
| `$pilha`     | `26`     | Stack pointer to a param list | # register reserved for the compiler |
| `$t0 - $t25` | `0 - 25` | Temporary                     |

## Error Handling

The assembler will print an error message to the terminal if it encounters an error while assembling the code.
