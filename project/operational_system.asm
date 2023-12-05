# Nesse arquivo vai ser escrito o código de um sistema operacional para um processador MIPS com funcionalidades reduzidas
# O sistema operacional deve possuir um prompt de comando que deve perguntar ao usuário duas opções:
# 1 - Executar um programa em Assembly MIPS reduzida
# 2 - Executar vários programas com preempção
# O sistema operacional deve possuir um gerenciador de processos que deve ser capaz de executar vários programas em Assembly MIPS reduzida
# O sistema operacional deve possuir um gerenciador de memória que deve ser capaz de gerenciar a memória de um programa em Assembly MIPS reduzida
# O sistema operacional será escrito na linguagem assembly MIPS reduzida

# TODO - Alterar a forma que são armazenados a pilha de parametros no compilador


%define pc_so 0
%define var_controle 1
%define var_total 2
%define var_i 3
%define buffer 4
%define interruption 5
%define id_procs 6
%define state_procs 17
%define contexto 28
%define program_size 300
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

    pc $t2 $zero 0                 # Guarda o valor do pc atual em um registrador
    addi $t2 $t2 7                 # Soma 7 ao valor do pc atual para apontar para o nop
    sw $t2 pc_so($zero)         
    ori $t3 $zero program_size              
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
            add $t6 $zero $t2 # $t6 = id
            # subi $t6 $t6 1
            ori $t4 $zero 33 
            mul $s0 $t6 $t4
            out $zero $s0 0
            lw $s2 contexto($s0) # 33*ID + 2035
            #out $zero $s2 0
            jal carrega_contexto # Carrega o contexto do programa que está sendo executado
            out $zero $s0 0
            lw $ra contexto($s0)
            #out $zero $ra 0
            j end_if2

        else2:
            # Caso o programa não esteja sendo executado, executar o programa a partir do seu pc inicial
            ori $t3 $zero program_size              
            mul $s2 $t2 $t3

        end_if2:

        # Troca de contexto já foi feita. Utilizar só registradores $s0 e $s1
        pc $s0 $zero 0
        addi $s0 $s0 8
        sw $s0 pc_so($zero)
       
        # Calcula o valor inicial do frame de memória do programa
        ori $s0 $zero data_size
        mul $s0 $s1 $s0

        disp $zero $s1 4 # Imprimir no display o programa escolhido pelo usuário
        
        clk $zero $zero 40 # Executa o programa por 20 ciclos de clock   
        jr $zero $s2 $zero 

        nop 
        disp $zero $zero 0 # Imprimir no display que o SO está executando
        # --- Aqui tudo precisa ser feito com registradores reservados ---
        checkint $s0 $zero 0 # Verifica qual interrupção ocorreu
        
        ori $s1 $zero 2

        # --- Interrupção de tempo - Levar para o final da fila de execução ---
        beq $s0 $s1 else3
            lw $s2 id_procs($zero) # $s0 = id do programa que está sendo executado
            # subi $t6 $t6 1
            ori $s1 $zero 33 
            mul $s0 $s2 $s1

            pci $s1 $zero 0 # Salva o pc do programa que está sendo executado
            #out $zero $s1 0
            sw $s1 contexto($s0) # Salva o contexto do programa que está sendo executado
            out $zero $s0 0

            # TODO: Só armazenar o valor do $ra em um registrador reservado
            #addi $s0 $s0 28
            #out $zero $s0 0
            #sw $ra contexto($s0) # Salva o $ra do programa que estava sendo executado
            #out $zero $ra 0
            #subi $s0 $s0 28
            
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
    addi $s0 $s0 1
    lw $t0 contexto($s0)
    addi $s0 $s0 1
    lw $t1 contexto($s0)
    addi $s0 $s0 1
    lw $t2 contexto($s0)
    addi $s0 $s0 1
    lw $t3 contexto($s0)
    addi $s0 $s0 1
    lw $t4 contexto($s0)
    addi $s0 $s0 1
    lw $t5 contexto($s0)
    addi $s0 $s0 1
    lw $t6 contexto($s0)
    addi $s0 $s0 1
    lw $t7 contexto($s0)
    addi $s0 $s0 1
    lw $t8 contexto($s0)
    addi $s0 $s0 1
    lw $t9 contexto($s0)
    addi $s0 $s0 1
    lw $t10 contexto($s0)
    addi $s0 $s0 1
    lw $t11 contexto($s0)
    addi $s0 $s0 1
    lw $t12 contexto($s0)
    addi $s0 $s0 1
    lw $t13 contexto($s0)
    addi $s0 $s0 1
    lw $t14 contexto($s0)
    addi $s0 $s0 1
    lw $t15 contexto($s0)
    addi $s0 $s0 1
    lw $t16 contexto($s0)
    addi $s0 $s0 1
    lw $t17 contexto($s0)
    addi $s0 $s0 1
    lw $t18 contexto($s0)
    addi $s0 $s0 1
    lw $t19 contexto($s0)
    addi $s0 $s0 1
    lw $t20 contexto($s0)
    addi $s0 $s0 1
    lw $t21 contexto($s0)
    addi $s0 $s0 1
    lw $t22 contexto($s0)
    addi $s0 $s0 1
    lw $pilha contexto($s0)
    addi $s0 $s0 1
    lw $temp contexto($s0)
    addi $s0 $s0 1
    lw $sp contexto($s0)
    addi $s0 $s0 1
    lw $fp contexto($s0)
    out $zero $fp 0
    addi $s0 $s0 1

    # Não esquecer de salvar o $ra na main
    jr $zero $ra $zero
    
salva_contexto:
    addi $s0 $s0 1
    sw $t0 contexto($s0)
    addi $s0 $s0 1
    sw $t1 contexto($s0)
    addi $s0 $s0 1
    sw $t2 contexto($s0)
    addi $s0 $s0 1
    sw $t3 contexto($s0)
    addi $s0 $s0 1
    sw $t4 contexto($s0)
    addi $s0 $s0 1
    sw $t5 contexto($s0)
    addi $s0 $s0 1
    sw $t6 contexto($s0)
    addi $s0 $s0 1
    sw $t7 contexto($s0)
    addi $s0 $s0 1
    sw $t8 contexto($s0)
    addi $s0 $s0 1
    sw $t9 contexto($s0)
    addi $s0 $s0 1
    sw $t10 contexto($s0)
    addi $s0 $s0 1
    sw $t11 contexto($s0)
    addi $s0 $s0 1
    sw $t12 contexto($s0)
    addi $s0 $s0 1
    sw $t13 contexto($s0)
    addi $s0 $s0 1
    sw $t14 contexto($s0)
    addi $s0 $s0 1
    sw $t15 contexto($s0)
    addi $s0 $s0 1
    sw $t16 contexto($s0)
    addi $s0 $s0 1
    sw $t17 contexto($s0)
    addi $s0 $s0 1
    sw $t18 contexto($s0)
    addi $s0 $s0 1
    sw $t19 contexto($s0)
    addi $s0 $s0 1
    sw $t20 contexto($s0)
    addi $s0 $s0 1
    sw $t21 contexto($s0)
    addi $s0 $s0 1
    sw $t22 contexto($s0)
    addi $s0 $s0 1
    sw $pilha contexto($s0)
    addi $s0 $s0 1
    sw $temp contexto($s0)
    addi $s0 $s0 1
    sw $sp contexto($s0)
    addi $s0 $s0 1
    sw $fp contexto($s0)
    out $zero $fp 0

    # Não esquecer de salvar o $ra na main
    jr $zero $ra $zero



