# Nesse arquivo vai ser escrito o código de um sistema operacional para um processador MIPS com funcionalidades reduzidas
# O sistema operacional deve possuir um prompt de comando que deve perguntar ao usuário duas opções:
# 1 - Executar um programa em Assembly MIPS reduzida
# 2 - Executar vários programas com preempção
# O sistema operacional deve possuir um gerenciador de processos que deve ser capaz de executar vários programas em Assembly MIPS reduzida
# O sistema operacional deve possuir um gerenciador de memória que deve ser capaz de gerenciar a memória de um programa em Assembly MIPS reduzida
# O sistema operacional será escrito na linguagem assembly MIPS reduzida

%define contexto 2500
%define var_controle 2000
%define var_i 2001
%define var_j 2002
%define vetor_processos 2005

inicio:              
    lw $t0 var_controle($zero)             # Carregar o valor do endereço de memória 2500 no registrador $t0
    beq $t0 $zero main
    disp $zero $zero 3             # Imprimir no display que houve uma interrupção
    lw $t0 contexto($zero)
    jr $zero $t0 $zero

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
    sw $t2 contexto($zero)         
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

        slt $t2 $t5 $zero
        xori $t2 $t2 1
        beq $t2 $zero end_if1

        ori $t2 $zero 10
        slt $t2 $t2 $t5
        xori $t2 $t2 1
        beq $t2 $zero end_if1

        slt $t2 $t5 $zero
        slt $t2 $zero $t5
        xori $t2 $t2 1
        beq $t2 $zero else1
        add $t1 $zero $zero
        j end_if1

        else1:
            sw $t5 vetor_processos($t0)
            addi $t0 $t0 1

        end_if1: 
        
        j while1
    end_while1:
    
    # Esse While deve executar todos os processos em forma de batch
    ori $t3 $zero 0
    out $zero $t3 0
    while2:
        slt $t2 $t3 $t0
        beq $t2 $zero end_while2
        lw $t4 vetor_processos($t3)
        out $zero $t4 0

        ori $t6 $zero 150              
        mul $t7 $t4 $t6
        out $zero $t7 0
        disp $zero $t4 4               # Imprimir no display o programa escolhido pelo usuário
        
        sw $t3 var_j($zero)
        sw $t0 var_i($zero)

        pc $t2 $zero 0                 
        addi $t2 $t2 5               
        sw $t2 contexto($zero)
        out $zero $t2 0
                 
        jr $zero $t7 $zero             # Carregar programa

        nop

        lw $t3 var_j($zero)
        lw $t0 var_i($zero)

        addi $t3 $t3 1
        out $zero $t3 0
        j while2

    end_while2:
    
    j main                      # Volta para o início do programa

salva_contexto:
    sw $t0 contexto($zero)          # Armazenar o valor do registrador $t0 no endereço de memória 2501
    sw $t1 contexto($zero)          # Armazenar o valor do registrador $t1 no endereço de memória 2502
    sw $t2 contexto($zero)          # Armazenar o valor do registrador $t2 no endereço de memória 2503
    sw $t3 contexto($zero)          # Armazenar o valor do registrador $t3 no endereço de memória 2504
    sw $t4 contexto($zero)                                      
    sw $t5 contexto($zero)                                      
    sw $t6 contexto($zero)                                      
    sw $t7 contexto($zero)                                      
    sw $t8 contexto($zero)                                      
    sw $t9 contexto($zero)                                      
    sw $t10 contexto($zero)                                     
    sw $t11 contexto($zero)                                     
    sw $t12 contexto($zero)                                     
    sw $t13 contexto($zero)                                     
    sw $t14 contexto($zero)                                     
    sw $t15 contexto($zero)                                     
    sw $t16 contexto($zero)                                     
    sw $t17 contexto($zero)                                     
    sw $t18 contexto($zero)                                     
    sw $t19 contexto($zero)                                     
    sw $t20 contexto($zero)                                     
    sw $t21 contexto($zero)                                     
    sw $t22 contexto($zero)                                     
    sw $t23 contexto($zero)                                     
    sw $t24 contexto($zero)                                     
    sw $t25 contexto($zero)                                     
    sw $sp  contexto($zero)                                      
    sw $fp  contexto($zero)          
    sw $ra  contexto($zero)          
    sw $pilha contexto($zero)          
    sw $temp contexto($zero)        

carrega_contexto:
    lw $t0 2501($zero)          # Carregar o valor do endereço de memória 2501 no registrador $t0
    lw $t1 2502($zero)          # Carregar o valor do endereço de memória 2502 no registrador $t1
    lw $t2 2503($zero)          # Carregar o valor do endereço de memória 2503 no registrador $t2
    lw $t3 2504($zero)          # Carregar o valor do endereço de memória 2504 no registrador $t3
    lw $t4 2505($zero)                                      
    lw $t5 2506($zero)                                      
    lw $t6 2507($zero)                                      
    lw $t7 2508($zero)                                      
    lw $t8 2509($zero)                                      
    lw $t9 2510($zero)                                      
    lw $t10 2511($zero)                                     
    lw $t11 2512($zero)                                     
    lw $t12 2513($zero)                                     
    lw $t13 2514($zero)                                     
    lw $t14 2515($zero)                                     
    lw $t15 2516($zero)                                     
    lw $t16 2517($zero)                                     
    lw $t17 2518($zero)                                     
    lw $t18 2519($zero)                                     
    lw $t19 2520($zero)                                     
    lw $t20 2521($zero)                                     
    lw $t21 2522($zero)                                     
    lw $t22 2523($zero)                                     
    lw $t23 2524($zero)                                     
    lw $t24 2525($zero)                                     
    lw $t25 2526($zero)                                     
    lw $sp 2527($zero)                                      
    lw $fp 2528($zero)          
    lw $ra 2529($zero)          
    lw $pilha 2530($zero)          
    lw $temp 2531($zero)