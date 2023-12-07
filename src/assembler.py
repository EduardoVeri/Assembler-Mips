"""Um assembler em python desenvolvido para a disciplina de Compiladores.

Ele deve ser capaz de ler um arquivo .txt com um código fonte em assembly MIPS
e converter para um arquivo .txt com o código em linguagem de máquina."""

# Importando as bibliotecas necessárias
import sys
import re

DEBUG = False

green = '\033[92m'
red = '\033[91m'
end = '\033[0m'

# Definindo as variáveis globais
# Dicionário com os registradores
reg = {
    '$zero': '11111',
    '$ra' : '11110',
    '$fp' : '11101',
    '$sp' : '11100',
    '$temp' : '11011',
    '$pilha' : '11010',
    '$s2' : '11001',
    '$s1' : '11000',
    '$s0' : '10111',
    '$t22' : '10110',
    '$t21' : '10101',
    '$t20' : '10100',
    '$t19' : '10011',
    '$t18' : '10010',
    '$t17' : '10001',
    '$t16' : '10000',
    '$t15' : '01111',
    '$t14' : '01110',
    '$t13' : '01101',
    '$t12' : '01100',
    '$t11' : '01011',
    '$t10' : '01010',
    '$t9' : '01001',
    '$t8' : '01000',
    '$t7' : '00111',
    '$t6' : '00110',
    '$t5' : '00101',
    '$t4' : '00100',
    '$t3' : '00011',
    '$t2' : '00010',
    '$t1' : '00001',
    '$t0' : '00000'
}

# Dicionário com as instruções do tipo I
instr_I = {
    'addi': '001000',
    'andi': '001100',
    'ori': '001101',
    'xori': '101101',
    'lw': '100011',
    'sw': '101011',
    'beq': '000100',
    'bne': '000101',
    'slti': '001010',
    'in': '011111',
    'out': '011110',
    'subi': '001001',
    'disp': '111110',
    'pc': '100100',
    'pci' : '110100',
    'clk' : '000001',
    'checkint' : '000110'
}

instr_J = {
    'j': '000010',
    'jal': '000011',
    'halt': '111111'
}

# Dicionário com os functs das instruções
funct = {
    'add': '100000',
    'sub': '100010',
    'and': '100100',
    'or': '100101',
    'xor': '101101',
    'nor': '100111',
    'slt': '101010',
    'sll': '000000',
    'srl': '000010',
    'jr': '001000',
    'mul': '011000',
    'div': '011010',
    'jalr': '001001'
}

# Dicionário com as labels e constantes
label = {}
const = {}

def show_error(linha, msg):
    print(red, f'Erro de sintaxe na linha ', end, linha, sep='')
    print(msg)
    sys.exit()

def bin_R(arq, tokens, linha):
    # Verificando se o número de tokens está correto
    if len(tokens) != 4:
        show_error(linha, 'Número de tokens inválido!')
        
    # Verificando se o primeiro token é um registrador
    if tokens[1] not in reg:
        show_error(linha, 'Registrador 1 inválido!')
    
    # Verificando se o segundo token é um registrador
    if tokens[2] not in reg:
        show_error(linha, 'Registrador 2 inválido!')
    
    # Verificando se o terceiro token é um registrador
    if tokens[3] not in reg:
        show_error(linha, 'Registrador 3 inválido!')
        
    # Escrevendo o código em linguagem de máquina no arquivo de saída
    arq.write('000000' + reg[tokens[2]] + reg[tokens[3]] + reg[tokens[1]] + '00000' + funct[tokens[0]] + '\n')

def bin_I(arq, tokens, linha):
    # Verificando se o número de tokens está correto
    if len(tokens) != 4:
        show_error(linha, 'Número de tokens inválido!')
    
    # Verificando se o primeiro token é um registrador
    if tokens[1] not in reg:
        show_error(linha, 'Registrador 1 inválido!')
    
    # Verificando a instrução atual, pois o registrador 2 pode ser um registrador ou um imediato
    if tokens[0] in ['beq', 'bne']:
        if tokens[2] not in reg:
            show_error(linha, 'Registrador 2 inválido!')
            
        # TODO: Fazer uma varredura no arquivo inteiro para armazenar as labels e seus endereços 
        # Verificando se o terceiro token é uma label
        if tokens[3] not in label:
            show_error(linha, 'Label inválida!')
        
        # Traduzir a label para um valor imediato de 16 bits
        tokens[3] = bin(label[tokens[3]])[2:].zfill(16)

        # Escrevendo o código em linguagem de máquina no arquivo de saída
        arq.write(instr_I[tokens[0]] + reg[tokens[1]] + reg[tokens[2]] + str(tokens[3]) + '\n')
    
    elif tokens[0] in ['lw', 'sw']:

        
        if tokens[2] in const:
            tokens[2] = const[tokens[2]]
        
        # Verificar se o segundo token é um inteiro:
        if not tokens[2].isdigit():
            show_error(linha, 'Imediato inválido! Não representa um inteiro!')
            
        # Verificar se o inteiro é um número de 16 bits
        if int(tokens[2]) > 65535:
            show_error(linha, 'Imediato inválido! Não representa um número de 16 bits!')
        
        # Verificar se o terceiro token é um registrador
        if tokens[3] not in reg:
            show_error(linha, 'Registrador 3 inválido!')
        
        # Converter o imediato para binario de 16 bits
        tokens[2] = bin(int(tokens[2]))[2:].zfill(16)

        # Escrevendo o código em linguagem de máquina no arquivo de saída
        arq.write(instr_I[tokens[0]] + reg[tokens[3]] + reg[tokens[1]] + tokens[2] + '\n')
    else:
        
        if tokens[3] in const:
            tokens[3] = const[tokens[3]]
            
        # Verificar se o segundo token é um inteiro:
        if not tokens[3].isdigit():
            show_error(linha, 'Imediato inválido! Não representa um inteiro!')
        
        # Verificar se o inteiro é um número de 16 bits
        if int(tokens[3]) > 65535:
            show_error(linha, 'Imediato inválido! Não representa um número de 16 bits!')

        if tokens[2] not in reg:
            show_error(linha, 'Registrador 2 inválido!')

        # Converter o imediato para binario de 16 bits
        tokens[3] = bin(int(tokens[3]))[2:].zfill(16)

        # Escrevendo o código em linguagem de máquina no arquivo de saída
        arq.write(instr_I[tokens[0]] + reg[tokens[2]] + reg[tokens[1]] + tokens[3] + '\n')

def bin_J(arq, tokens, linha):
    if tokens[0] == 'halt':
        # Escrevendo o código em linguagem de máquina no arquivo de saída
        arq.write(instr_J[tokens[0]] + 26*'0' + '\n')
        return
    
    # Verificando se o número de tokens está correto
    if len(tokens) != 2:
        show_error(linha, 'Número de tokens inválido!')

    # Verificando se o primeiro token é uma label
    if tokens[1] not in label:
        show_error(linha, 'Label inválida!')
    
    # Traduzir a label para um valor imediato de 26 bits
    tokens[1] = bin(label[tokens[1]])[2:].zfill(26)

    # Escrevendo o código em linguagem de máquina no arquivo de saída
    arq.write(instr_J[tokens[0]] + tokens[1] + '\n')

def print_nop(arq):
    arq.write('00000011111111111111100000100000\n')

def main():
    # Abrindo o arquivo .txt com o código fonte
    
    name_arq_in = None
    name_arq_out = None
    
    if len(sys.argv) == 1:
        name_arq_in = "input.txt"
        name_arq_out = "output.txt"
        
    elif len(sys.argv) == 3:
        if "-i" in sys.argv:
            name_arq_in = sys.argv[sys.argv.index("-i") + 1]
            name_arq_out = "output.txt"
        elif "-o" in sys.argv:
            name_arq_in = "input.txt"
            name_arq_out = sys.argv[sys.argv.index("-o") + 1]
        else:
            name_arq_in = sys.argv[1]
            name_arq_out = sys.argv[2]
            
    elif "-i" in sys.argv and  "-o" in sys.argv:
        name_arq_in = sys.argv[sys.argv.index("-i") + 1]
        name_arq_out = sys.argv[sys.argv.index("-o") + 1]
        
    else:
        print("Argumentos inválidos!")
        print(f"Use: python {sys.argv[0]} -i <input_file> -o <output_file>")
        print(f"Ou: python {sys.argv[0]} <input_file> <output_file>")
        sys.exit()
    
    try:
        arq_in = open(name_arq_in, 'r')
    except:
        print(red, f'Erro ao abrir o arquivo! Arquivo "{name_arq_in}" não encontrado', end, sep='')
        sys.exit()

    # Abrindo o arquivo .txt para escrever o código em linguagem de máquina
    try:
        arq_out = open(name_arq_out, 'w')
    except:
        print(red, f'Erro ao abrir o arquivo de saída! Arquivo "{name_arq_out}" não encontrado', end, sep='')
        sys.exit()

    tokens_list = []

    total_lines = 0
    # Lendo o arquivo .txt com o código fonte
    for linha in arq_in:
        # Removendo os espaços em branco
        linha = linha.strip()

        # Removendo os comentários
        linha = re.sub(r'#.*', '', linha)

        # Removendo os espaços em branco
        linha = linha.strip()

        # Verificando se a linha não está vazia
        if linha != '':
            # Verificando se a linha é uma label
            if linha[-1] == ':':
                # Adicionando a label no dicionário
                label[linha[:-1]] = total_lines
                tokens_list.append(([linha[:-1]], str(total_lines) + ": " + linha))
                total_lines += 1
            # Verificando se a linha é uma definição de constante
            elif linha[0] == '%':
                # Adicionando a constante no dicionário: Modo de usar: %define constante valor
                tokens = list(filter(None, re.split(r'\s+|\(|\)', linha)))
                const[tokens[1]] = tokens[2]
            else:
                # Separando a linha em tokens
                tokens = list(filter(None, re.split(r'\s+|\(|\)', linha)))
                tokens_list.append((tokens, str(total_lines) + ": " + linha))
                total_lines += 1
        
    for tokens, linha in tokens_list:
        
        if(DEBUG):
            arq_out.write(linha + (40 - len(linha))*' ')
            
        # Verificando se o primeiro token é uma instrução e qual o seu tipo
        if tokens[0] in funct:
            bin_R(arq_out, tokens, linha)
        elif tokens[0] in instr_I:
            bin_I(arq_out, tokens, linha)
        elif tokens[0] in instr_J:
            bin_J(arq_out, tokens, linha)
        elif tokens[0] in label or tokens[0] == 'nop':
            print_nop(arq_out)
        else:
            show_error(linha, 'Instrução inválida!')

    # Fechando os arquivos
    arq_in.close()
    arq_out.close()

    print(green,'Arquivo de saída gerado com sucesso!', end, sep='')


if __name__ == '__main__':
    main()

