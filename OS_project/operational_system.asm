# Nesse arquivo vai ser escrito o código de um sistema operacional para um processador MIPS com funcionalidades reduzidas
# O sistema operacional deve possuir um prompt de comando que deve perguntar ao usuário duas opções:
# 1 - Executar um programa em Assembly MIPS reduzida
# 2 - Executar vários programas com preempção
# O sistema operacional deve possuir um gerenciador de processos que deve ser capaz de executar vários programas em Assembly MIPS reduzida
# O sistema operacional deve possuir um gerenciador de memória que deve ser capaz de gerenciar a memória de um programa em Assembly MIPS reduzida
# O sistema operacional será escrito na linguagem assembly MIPS reduzida


%define pc_so 0
%define var_controle 1
%define var_total 2
%define var_i 3
%define buffer 4
%define interruption 5
%define id_procs 6
%define state_procs 17
%define contexto 50
%define so_size 300
%define program_size 150
%define data_size 300


inicio:              
    lw $s1 var_controle($zero)     # Carregar o valor do endereço de memória 2500 no registrador $t0
    beq $s1 $zero main
    disp $zero $zero 3             # Imprimir no display que houve uma interrupção

    # Voltar para onde o SO estava executando
    lw $s1 pc_so($zero)
    jr $zero $s1 $zero

main:
    ori $t1 $zero 1
    ori $t2 $zero 2                    
    sw $t1 var_controle($zero) # Assim que o programa é efetuado pela primeira vez, sobrescreve o valor 0 por 1

    disp $zero $zero 1  # Imprimir no display as opções disponíveis para o usuário
    in $t0 $zero 0              

    beq $t0 $t1 escolha1   # Se o usuário digitar 1, executar um programa
    beq $t0 $t2 escolha2   # Se o usuário digitar 2, executar vários programas com preempção
    j main                 # Volta para o início do programa

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
    
    #add $s0 $zero $zero            # Atribui o valor do frame de memória do programa escolhido pelo usuário ao registrador $s0
    ori $s0 $zero data_size
    add $s2 $zero $t0


    pc $t2 $zero 0  # Guarda o valor do pc atual em um registrador
    addi $t2 $t2 9  # Soma ## ao valor do pc atual para apontar para o nop
    sw $t2 pc_so($zero)   

    ori $t3 $zero program_size
    subi $t0 $t0 1                              
    mul $t4 $t0 $t3
    addi $t4 $t4 so_size

    disp $zero $s2 4               # Imprimir no display o programa escolhido pelo usuário   

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
        bne $t5 $zero else1
            add $t1 $zero $zero # bool = 0
            j end_if1

        # Salva o id do programa a ser executado
        else1:
            sw $t5 id_procs($t0) # id_procs[i] = input()
            sw $zero state_procs($t0) # state_procs[i] = 0 

            addi $t0 $t0 1

        end_if1: 
        
        j while1
    end_while1:
    
    sw $t0 var_total($zero) # total = i

    while2:
        disp $zero $zero 0 # Imprimir no display que o SO está executando
        lw $t0 var_total($zero)
        slt $t1 $zero $t0
        beq $t1 $zero end_while2

        lw $t1 state_procs($zero) # state = state_procs[0]
        lw $t2 id_procs($zero) # id = id_procs[0]
        add $s1 $t2 $zero # $s1 = id


        beq $t1 $zero else2
            ori $t4 $zero 33 
            mul $s0 $t2 $t4
            addi $s0 $s0 contexto
            lw $s2 0($s0) # Carrega o PC do programa após a interrupção

            jal carrega_contexto # Carrega o contexto do programa que está sendo executado

            lw $ra 28($s0)

            j end_if2

        else2:
            # Caso o programa não esteja sendo executado, executar o programa a partir do seu pc inicial
            ori $t3 $zero program_size  
            subi $t2 $t2 1            
            mul $s2 $t2 $t3
            addi $s2 $s2 so_size

        end_if2:

        # Troca de contexto já foi feita. Utilizar só registradores $s0 e $s1
        pc $s0 $zero 0
        addi $s0 $s0 8
        sw $s0 pc_so($zero)
       
        # Calcula o valor inicial do frame de memória do programa
        ori $s0 $zero data_size
        mul $s0 $s1 $s0

        disp $zero $s1 4 # Imprimir no display o programa escolhido pelo usuário
        
        clk $zero $zero 35 # Executa o programa por N ciclos de clock   
        jr $zero $s2 $zero 

        nop 

        #disp $zero $zero 0 # Imprimir no display que o SO está executando

        # --- Aqui tudo precisa ser feito com registradores reservados ---
        checkint $s0 $zero 0 # Verifica qual interrupção ocorreu
        
        ori $s1 $zero 2

        # --- Interrupção de tempo - Levar para o final da fila de execução ---
        beq $s0 $s1 else3
            lw $s2 id_procs($zero) # $s0 = id do programa que está sendo executado

            ori $s1 $zero 33 
            mul $s0 $s2 $s1
            addi $s0 $s0 contexto

            pci $s1 $zero 0 # Salva o pc do programa que está sendo executado
            sw $s1 0($s0) # Salva o contexto do programa que está sendo executado
            sw $ra 28($s1) # Salva o $ra do programa que estava sendo executado
            
            jal salva_contexto
            
            ori $t0 $zero 0
            add $t1 $zero $s2  # buffer_proc = id_procs[0]
            lw $t2 var_total($zero) 
            subi $t2 $t2 1
                
            while3:
                slt $t3 $t0 $t2
                beq $t3 $zero end_while3
                
                addi $t4 $t0 id_procs
                lw $t5 1($t4) # $t5 = id_procs[i+1]
                sw $t5 id_procs($t0) # id_procs[i] = id_procs[i+1]
                
                addi $t4 $t0 state_procs
                lw $t5 1($t4) # $t5 = state_procs[i+1]
                sw $t5 state_procs($t0) # state_procs[i] = state_procs[i+1]

                addi $t0 $t0 1

                j while3

            end_while3:

            sw $t1 id_procs($t2) # id_procs[total-1] = buffer_proc
            ori $t6 $zero 1
            sw $t6 state_procs($t2) # state_procs[total-1] = buffer_state

            j end_if3

        # --- Halt do programa. Excluir o programa da lista de programas a serem executados ---
        else3:
            ori $t0 $zero 0 # i = 0
            lw $t1 var_total($zero) # total = var_total
            subi $t1 $t1 1

            while4:
                slt $t2 $t0 $t1
                beq $t2 $zero end_while4
                
                addi $t3 $t0 id_procs
                lw $t4 1($t3) # $t4 = id_procs[i+1]
                sw $t4 id_procs($t0) # id_procs[i] = id_procs[i+1]
                
                addi $t3 $t0 state_procs
                lw $t4 1($t3) # $t4 = state_procs[i+1]
                sw $t4 state_procs($t0) # state_procs[i] = state_procs[i+1]

                addi $t0 $t0 1

                j while4
            end_while4:

            sw $t1 var_total($zero) # var_total = total - 1

        end_if3:

        j while2

    end_while2:
    
    j main                      # Volta para o início do programa


# Carrega o contexto do programa que está sendo executado
carrega_contexto:
    lw $t0 1($s0)
    lw $t1 2($s0)
    lw $t2 3($s0)
    lw $t3 4($s0)
    lw $t4 5($s0)
    lw $t5 6($s0)
    lw $t6 7($s0)
    lw $t7 8($s0)
    lw $t8 9($s0)
    lw $t9 10($s0)
    lw $t10 11($s0)
    lw $t11 12($s0)
    lw $t12 13($s0)
    lw $t13 14($s0)
    lw $t14 15($s0)
    lw $t15 16($s0)
    lw $t16 17($s0)
    lw $t17 18($s0)
    lw $t18 19($s0)
    lw $t19 20($s0)
    lw $t20 21($s0)
    lw $t21 22($s0)
    lw $t22 23($s0)
    lw $pilha 24($s0)
    lw $temp 25($s0)
    lw $sp 26($s0)
    lw $fp 27($s0)

    # Não esquecer de salvar o $ra na main
    jr $zero $ra $zero
    
salva_contexto:
    sw $t0 1($s0)
    sw $t1 2($s0)
    sw $t2 3($s0)
    sw $t3 4($s0)
    sw $t4 5($s0)
    sw $t5 6($s0)
    sw $t6 7($s0)
    sw $t7 8($s0)
    sw $t8 9($s0)
    sw $t9 10($s0)
    sw $t10 11($s0)
    sw $t11 12($s0)
    sw $t12 13($s0)
    sw $t13 14($s0)
    sw $t14 15($s0)
    sw $t15 16($s0)
    sw $t16 17($s0)
    sw $t17 18($s0)
    sw $t18 19($s0)
    sw $t19 20($s0)
    sw $t20 21($s0)
    sw $t21 22($s0)
    sw $t22 23($s0)
    sw $pilha 24($s0)
    sw $temp 25($s0)
    sw $sp 26($s0)
    sw $fp 27($s0)

    # Não esquecer de salvar o $ra na main
    jr $zero $ra $zero



