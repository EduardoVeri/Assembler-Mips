# Reduced-Functionality MIPS Processor Operating System

This is a simplified operating system designed for a MIPS processor with reduced functionality. 
The MIPS processor used here was created by me as part of a university project for the course "Computer Architecture and Organization Lab" at UNIFESP.
The Operational System was created by me as part of a university project for the course "Operating Systems Lab" at UNIFESP.

The operating system provides a command prompt that allows the user to choose between two options:

1. Execute a program in reduced MIPS Assembly.
2. Execute multiple programs with preemption.

The operating system includes a process manager capable of running programs in reduced MIPS Assembly and a memory manager to manage program memory.

## Usage Instructions

1. Compile the reduced MIPS Assembly code using the assembler in this repository (see [src]).
2. Load the generated code into the MIPS processor's memory.
3. Execute the operating system.

## Features

### 1. Execute a Program in Reduced MIPS Assembly

When the operating system is run, it offers the option to execute a program in reduced MIPS Assembly. The user can choose from various available programs. The system loads the selected program into memory and executes it.

### 2. Execute Multiple Programs with Preemption

The operating system also provides the option to execute multiple programs with preemption. When this option is selected, the system can switch between different running programs, saving and restoring the context of each program. This allows concurrent execution of multiple programs.

## Notes

- The provided code is a simplified and illustrative representation of an operating system for a MIPS processor with reduced functionality. It is not functional on its own and must be adapted and integrated into a suitable MIPS development environment.

- The complete implementation of an operating system requires many more features and considerations for security, scalability, and resource management. This code serves only as a conceptual introduction to the basic operations of an operating system.

- Ensure that you adapt the code and operations to the specifications of your MIPS environment and the needs of your system.
