"""Um assembler em python desenvolvido para a disciplina de Compiladores.

Ele deve ser capaz de ler um arquivo .txt com um código fonte em assembly MIPS
e converter para um arquivo .txt com o código em linguagem de máquina."""

# Importando as bibliotecas necessárias
import sys
import re
import argparse

from mips.mips_config import reg, instr_R, instr_I, instr_J, funct

DEBUG = False

GREEN = "\033[92m"
RED = "\033[91m"
RESET = "\033[0m"

# Definindo as variáveis globais

# Dicionário com as labels e constantes
label = {}
const = {}


def show_error(linha, msg):
    print(RED, f"Erro de sintaxe na linha ", RESET, linha, sep="")
    print(msg)
    sys.exit()


def bin_R(arq, tokens, linha):
    # Verificando se o número de tokens está correto
    if len(tokens) != 4:
        show_error(linha, "Número de tokens inválido!")

    # Verificando se o primeiro token é um registrador
    if tokens[1] not in reg:
        show_error(linha, "Registrador 1 inválido!")

    # Verificando se o segundo token é um registrador
    if tokens[2] not in reg:
        show_error(linha, "Registrador 2 inválido!")

    # Verificando se o terceiro token é um registrador
    if tokens[3] not in reg:
        show_error(linha, "Registrador 3 inválido!")

    # Escrevendo o código em linguagem de máquina no arquivo de saída
    arq.write(
        instr_R["all"]
        + reg[tokens[2]]
        + reg[tokens[3]]
        + reg[tokens[1]]
        + "00000"
        + funct[tokens[0]]
        + "\n"
    )


def bin_I(arq, tokens, linha):
    # Verificando se o número de tokens está correto
    if len(tokens) != 4:
        show_error(linha, "Número de tokens inválido!")

    # Verificando se o primeiro token é um registrador
    if tokens[1] not in reg:
        show_error(linha, "Registrador 1 inválido!")

    # Verificando a instrução atual, pois o registrador 2 pode ser um registrador ou um imediato
    if tokens[0] in ["beq", "bne"]:
        if tokens[2] not in reg:
            show_error(linha, "Registrador 2 inválido!")

        # TODO: Fazer uma varredura no arquivo inteiro para armazenar as labels e seus endereços
        # Verificando se o terceiro token é uma label
        if tokens[3] not in label:
            show_error(linha, "Label inválida!")

        # Traduzir a label para um valor imediato de 16 bits
        tokens[3] = bin(label[tokens[3]])[2:].zfill(16)

        # Escrevendo o código em linguagem de máquina no arquivo de saída
        arq.write(
            instr_I[tokens[0]] + reg[tokens[1]] + reg[tokens[2]] + str(tokens[3]) + "\n"
        )

    elif tokens[0] in ["lw", "sw"]:

        if tokens[2] in const:
            tokens[2] = const[tokens[2]]

        # Verificar se o segundo token é um inteiro:
        if not tokens[2].isdigit():
            show_error(linha, "Imediato inválido! Não representa um inteiro!")

        # Verificar se o inteiro é um número de 16 bits
        if int(tokens[2]) > 65535:
            show_error(linha, "Imediato inválido! Não representa um número de 16 bits!")

        # Verificar se o terceiro token é um registrador
        if tokens[3] not in reg:
            show_error(linha, "Registrador 3 inválido!")

        # Converter o imediato para binario de 16 bits
        tokens[2] = bin(int(tokens[2]))[2:].zfill(16)

        # Escrevendo o código em linguagem de máquina no arquivo de saída
        arq.write(
            instr_I[tokens[0]] + reg[tokens[3]] + reg[tokens[1]] + tokens[2] + "\n"
        )
    else:

        if tokens[3] in const:
            tokens[3] = const[tokens[3]]

        # Verificar se o segundo token é um inteiro:
        if not tokens[3].isdigit():
            show_error(linha, "Imediato inválido! Não representa um inteiro!")

        # Verificar se o inteiro é um número de 16 bits
        if int(tokens[3]) > 65535:
            show_error(linha, "Imediato inválido! Não representa um número de 16 bits!")

        if tokens[2] not in reg:
            show_error(linha, "Registrador 2 inválido!")

        # Converter o imediato para binario de 16 bits
        tokens[3] = bin(int(tokens[3]))[2:].zfill(16)

        # Escrevendo o código em linguagem de máquina no arquivo de saída
        arq.write(
            instr_I[tokens[0]] + reg[tokens[2]] + reg[tokens[1]] + tokens[3] + "\n"
        )


def bin_J(arq, tokens, linha):
    if tokens[0] == "halt":
        # Escrevendo o código em linguagem de máquina no arquivo de saída
        arq.write(instr_J[tokens[0]] + 26 * "0" + "\n")
        return

    # Verificando se o número de tokens está correto
    if len(tokens) != 2:
        show_error(linha, "Número de tokens inválido!")

    # Verificando se o primeiro token é uma label
    if tokens[1] not in label:
        show_error(linha, "Label inválida!")

    # Traduzir a label para um valor imediato de 26 bits
    tokens[1] = bin(label[tokens[1]])[2:].zfill(26)

    # Escrevendo o código em linguagem de máquina no arquivo de saída
    arq.write(instr_J[tokens[0]] + tokens[1] + "\n")


def print_nop(arq):
    arq.write(f'{instr_R["all"]}{reg["$zero"]*3}00000{funct["add"]}\n')


def main():
    # Using argparse to parse command-line arguments
    parser = argparse.ArgumentParser(description="MIPS Assembler")
    parser.add_argument("-i", "--input", default="input.txt", help="Input file")
    parser.add_argument("-o", "--output", default="output.txt", help="Output file")
    parser.add_argument(
        "pos_input", nargs="?", help="Input file (positional, optional)"
    )
    parser.add_argument(
        "pos_output", nargs="?", help="Output file (positional, optional)"
    )
    args = parser.parse_args()
    # Override flag arguments if positional arguments are provided
    name_arq_in = args.pos_input if args.pos_input else args.input
    name_arq_out = args.pos_output if args.pos_output else args.output

    try:
        arq_in = open(name_arq_in, "r")
    except:
        print(
            RED,
            f'Erro ao abrir o arquivo! Arquivo "{name_arq_in}" não encontrado',
            RESET,
            sep="",
        )
        sys.exit()

    try:
        arq_out = open(name_arq_out, "w")
    except:
        print(
            RED,
            f'Erro ao abrir o arquivo de saída! Arquivo "{name_arq_out}" não encontrado',
            RESET,
            sep="",
        )
        sys.exit()

    tokens_list = []

    total_lines = 0
    total_effective_lines = 0
    # Lendo o arquivo .txt com o código fonte
    for linha in arq_in:
        total_lines += 1
        # Removendo os espaços em branco
        linha = linha.strip()

        # Removendo os comentários
        linha = re.sub(r"#.*", "", linha)

        # Removendo os espaços em branco
        linha = linha.strip()

        # Verificando se a linha não está vazia
        if linha != "":
            # Verificando se a linha é uma label
            if linha[-1] == ":":
                # Adicionando a label no dicionário
                label[linha[:-1]] = total_effective_lines
                tokens_list.append(
                    ([linha[:-1]], str(total_effective_lines) + ": " + linha)
                )
                total_effective_lines += 1
            # Verificando se a linha é uma definição de constante
            elif linha[0] == "%":
                # Adicionando a constante no dicionário: Modo de usar: %define constante valor
                tokens = list(filter(None, re.split(r"\s+|\(|\)", linha)))
                const[tokens[1]] = tokens[2]
            else:
                # Separando a linha em tokens
                tokens = list(filter(None, re.split(r"\s+|\(|\)", linha)))
                tokens_list.append((tokens, str(total_lines) + ": " + linha))
                total_effective_lines += 1

    for tokens, linha in tokens_list:

        if DEBUG:
            arq_out.write(linha + (40 - len(linha)) * " ")

        # Verificando se o primeiro token é uma instrução e qual o seu tipo
        if tokens[0] in funct:
            bin_R(arq_out, tokens, linha)
        elif tokens[0] in instr_I:
            bin_I(arq_out, tokens, linha)
        elif tokens[0] in instr_J:
            bin_J(arq_out, tokens, linha)
        elif tokens[0] in label or tokens[0] == "nop":
            print_nop(arq_out)
        else:
            show_error(linha, "Instrução inválida!")

    # Fechando os arquivos
    arq_in.close()
    arq_out.close()

    print(GREEN, "Arquivo de saída gerado com sucesso!", RESET, sep="")


if __name__ == "__main__":
    main()
