"""Um interpretador python desenvolvido para a disciplina de Compiladores.

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

# Dicionário com as instruções
instr = {
    'add': '000000',
    'sub': '000001',
    'and': '000010',
    'or': '000011',
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

# Abrindo o arquivo .txt com o código fonte
try:
    arquivo = open(sys.argv[1], 'r')
except:
    print('Erro ao abrir o arquivo! Arquivo não encontrado')
    sys.exit()

