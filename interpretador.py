"""Um assembler em python desenvolvido para a disciplina de Compiladores.

Ele deve ser capaz de ler um arquivo .txt com um código fonte em assembly MIPS
e converter para um arquivo .txt com o código em linguagem de máquina."""

# Importando as bibliotecas necessárias
import sys
import re
import os

# Definindo as variáveis globais
# Dicionário com os registradores
reg = {
    '$zero': '00000',
    '$at': '00001',
    '$v0': '00010',
    '$v1': '00011',
    '$a0': '00100',
    '$a1': '00101',
    '$a2': '00110',
    '$a3': '00111',
    '$t0': '01000',
    '$t1': '01001',
}

# Dicionário com as instruções do tipo R
instr_R = {
    'add': '000000',
    'sub': '000001',
}

# Dicionário com as instruções do tipo I
instr_I = {
    'add': '000000',
    'sub': '000001',
    'and': '000010',
    'or': '000011',
}

instr_J = {
    'j': '000010',
    'jal': '000011',
}

# Dicionário com os functs das instruções
funct = {
    'add': '100000',
    'sub': '100010',
    'and': '100100',
    'or': '100101',
}

# Dicionário com as labels
label = {}


def bin_R(arq, tokens, linha):
    # Verificando se o número de tokens está correto
    if len(tokens) != 4:
        print('Erro de sintaxe na linha: ', linha)
        print('Número de tokens inválido!')
        sys.exit()
    
    # Verificando se o primeiro token é um registrador
    if tokens[1] not in reg:
        print('Erro de sintaxe na linha: ', linha)
        print('Registrador 1 inválido!')
        sys.exit()
    
    # Verificando se o segundo token é um registrador
    if tokens[2] not in reg:
        print('Erro de sintaxe na linha: ', linha)
        print('Registrador 2 inválido!')
        sys.exit()
    
    # Verificando se o terceiro token é um registrador
    if tokens[3] not in reg:
        print('Erro de sintaxe na linha: ', linha)
        print('Registrador 3 inválido!')
        sys.exit()
    
    # Escrevendo o código em linguagem de máquina no arquivo de saída
    arq.write(instr_R[tokens[0]] + reg[tokens[2]] + reg[tokens[3]] + reg[tokens[1]] + '00000' + funct[tokens[4]] + '\n')

def bin_I(arq, tokens, linha):
    # Verificando se o número de tokens está correto
    if len(tokens) != 4:
        print('Erro de sintaxe na linha: ', linha)
        print('Número de tokens inválido!')
        sys.exit()
    
    # Verificando se o primeiro token é um registrador
    if tokens[1] not in reg:
        print('Erro de sintaxe na linha: ', linha)
        print('Registrador 1 inválido!')
        sys.exit()
    
    # Verificando a instrução atual, pois o registrador 2 pode ser um registrador ou um imediato
    if tokens[0] in ['beq', 'bne']:
        if tokens[2] not in reg:
            print('Erro de sintaxe na linha: ', linha)
            print('Registrador 2 inválido!')
            sys.exit()
        
        # TODO: Fazer uma varredura no arquivo inteiro para armazenar as labels e seus endereços 
        # Verificando se o terceiro token é uma label
        if tokens[3] not in label:
            print('Erro de sintaxe na linha: ', linha)
            print('Label inválida!')
            sys.exit()
        
        

    



def bin_J(arq, tokens, linha):
    return



# Abrindo o arquivo .txt com o código fonte
try:
    arq_in = open(sys.argv[1], 'r')
except:
    print('Erro ao abrir o arquivo! Arquivo não encontrado')
    sys.exit()

# Abrindo o arquivo .txt para escrever o código em linguagem de máquina
try:
    arq_out = open(sys.argv[2], 'w')
except:
    print('Erro ao abrir o arquivo de saída!')
    sys.exit()

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
            label[linha[:-1]] = arq_out.tell()

        # Verificando se a linha é uma instrução
        else:
            # Separando a linha em tokens
            tokens = linha.split(" \n\t,()")

            # Verificando se o primeiro token é uma label
            if tokens[0][-1] == ':':
                # Removendo a label da lista de tokens
                tokens.pop(0)
                continue

            # Verificando se o primeiro token é uma instrução e qual o seu tipo
            if tokens[0] in instr_R:
                bin_R(arq_out, tokens, linha)
            elif tokens[0] in instr_I:
                bin_I(arq_out, tokens, linha)
            elif tokens[0] in instr_J:
                bin_J(arq_out, tokens, linha)
            else:
                print('Erro de sintaxe na linha: ', linha)
                print('Instrução inválida!')
                sys.exit()


