# Nesse arquivo vai ser escrito o código de um sistema operacional para um processador MIPS com funcionalidades reduzidas
# O sistema operacional deve possuir um prompt de comando que deve perguntar ao usuário duas opções:
# 1 - Executar um programa em Assembly MIPS reduzida
# 2 - Executar vários programas com preempção
# O sistema operacional deve possuir um gerenciador de processos que deve ser capaz de executar vários programas em Assembly MIPS reduzida
# O sistema operacional deve possuir um gerenciador de memória que deve ser capaz de gerenciar a memória de um programa em Assembly MIPS reduzida
# O sistema operacional será escrito na linguagem assembly MIPS reduzida

%define pc_so 2500
%define var_controle 2000
%define var_total 2001
%define var_i 2002
%define buffer 2003
%define interruption 2004
%define id_procs 2005
%define state_procs 2020
%define contexto 2035

inicio:              
    lw $s0 var_controle($zero)     # Carregar o valor do endereço de memória 2500 no registrador $t0
    beq $s0 $zero main
    disp $zero $zero 3             # Imprimir no display que houve uma interrupção

    # Voltar para onde o SO estava executando
    lw $s0 pc_so($zero)
    jr $zero $s0 $zero

main:
    ori $t1 $zero 1
    ori $t2 $zero 2                    
    sw $t1 var_controle($zero)             # Assim que o programa é efetuado pela primeira vez, sobrescreve o valor 0 por 1

    disp $zero $zero 1             # Imprimir no display as opções disponíveis para o usuário
    in $t0 $zero 0              

    beq $t0 $t1 escolha1           # Se o usuário digitar 1, executar um programa
    beq $t0 $t2 escolha2           # Se o usuário digitar 2, executar vários programas com preempção
    j main                         # Volta para o início do programa

# Executar um programa
escolha1:                       
    disp $zero $zero 2             # Imprimir no display os programas disponíveis para o usuário
    in $t0 $zero 0              

    # Verifica se o valor está entre 1 e 10
    ori $t4 $zero 1               
    slti $t1 $t0 1                 # Se o valor for menor que 0, $t1 = 1
    slti $t2 $t0 10                # Se o valor for menor que 10, $t2 = 1
    xori $t2 $t2 1                 # Inverte o valor de $t2
    or $t3 $t1 $t2                 # Se $t1 = 1 ou $t2 = 1, $t3 = 1
    beq $t3 $t4 escolha1           # Se $t3 = 0, o valor está entre 1 e 10
    
    pc $t2 $zero 0                 # Guarda o valor do pc atual em um registrador
    addi $t2 $t2 7                 # Soma 7 ao valor do pc atual para apontar para o nop
    sw $t2 pc_so($zero)         
    ori $t3 $zero 150              
    mul $t4 $t0 $t3
    disp $zero $t0 4               # Imprimir no display o programa escolhido pelo usuário             
    jr $zero $t4 $zero             # Carregar o endereço de memória onde o programa escolhido pelo usuário está armazenado

    nop 
           
    j main                         

# Executar vários programas com preempção
escolha2:                      
    ori $t0 $zero 0                # i = 0
    ori $t1 $zero 1                # bool = 1

    while1:
        beq $t1 $zero end_while1       # Se bool = 0, sair do loop
        disp $zero $zero 2             # Imprimir no display os programas disponíveis para o usuário
        in $t5 $zero 0

        # Verifica se o valor está entre 1 e 10
        slt $t2 $t5 $zero
        xori $t2 $t2 1
        beq $t2 $zero end_if1

        ori $t2 $zero 10
        slt $t2 $t2 $t5
        xori $t2 $t2 1
        beq $t2 $zero end_if1

        # Verifica se o valor é igual a 0 para sair do loop
        slt $t2 $t5 $zero
        slt $t2 $zero $t5
        xori $t2 $t2 1
        beq $t2 $zero else1
            add $t1 $zero $zero # bool = 0
            j end_if1

        # Salva o id do programa a ser executado
        else1:
            sw $t5 id_procs($t0) # id_procs[i] = input()

            ori $t3 $zero 0
            sw $t3 state_procs($t0) # state_procs[i] = 0 

            addi $t0 $t0 1

        end_if1: 
        
        j while1
    end_while1:
    
    while2:
        lw $t0 total($zero)
        slt $t1 $t0 $zero
        beq $t1 $zero end_while2

        lw $t1 state_procs($zero) # state = state_procs[0]
        lw $t2 id_procs($zero) # id = id_procs[0]

        ori $t4 $zero 1
        slt $t3 $t1 $t2
        slt $t3 $t2 $t1
        xori $t3 $t3 1
        beq $t3 $zero else2
            # TODO: Aqui eu preciso pegar da memória o valor do pc do programa que está sendo executado salvo na memória
            add $t6 $zero $t2 # $t6 = id
            subi $t6 $t6 1
            ori $t4 $zero 33 
            mul $t3 $t6 $t4

            lw $t3 contexto($t3) # 33*ID + 2035

            j end_if1

        else2:
            # Caso o programa não esteja sendo executado, executar o programa a partir do seu pc inicial
            ori $t3 $zero 150              
            mul $t3 $t2 $t3

        end_if1:

        # Calcula o valor inicial do frame de memória do programa
        ori $t5 $zero 500
        mul $t5 $t2 $t5
        add $s0 $zero $t5 # $s0 = pc

        # Salva o valor do pc do SO em um registrador
        
        pc $t5 $zero 0
        addi $t5 $t5 5
        sw $t5 pc_so($zero)
        disp $zero $t2 4             # Imprimir no display o programa escolhido pelo usuário

        jr $zero $t3 $zero 

        nop 

        


    end_while2:
    
    j main                      # Volta para o início do programa
