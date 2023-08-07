.intel_syntax noprefix

.section .text
.global main
.global bubblesort

bubblesort:
  //Configuracao da Pilha
  push rbp
  mov rbp, rsp
  sub rsp, 16

  //Armazenando na Pilha os argumentos da funcao
  mov [rsp + 8], rdi
  mov [rsp + 0], rsi

  init_loop:
    mov rcx, 0
    mov r12, 0
    
  loop:
    mov r8, [rsp + 0]
    cmp rcx, r8
    je done

    loop_2:
      mov rax, rcx
      mov r8, [rsp + 0]
      sub r8, rax
      cmp r12, r8
      je loop_done
    
      mov rax, [rsp + 8]
      mov rdx, [rax + r12 * 8]
      cmp rdx, [rax + (r12 + 1) * 8]
      jg swap
    
      loop_2_done:
        inc r12
      
      jmp loop_2

      swap:
        mov rax, [rsp + 8]
        mov rdx, [rax + r12 * 8]
        mov r9, [rax + (r12 + 1) * 8]
        mov [rax + r12 * 8], r9
        mov [rax + (r12 + 1) * 8], rdx
        jmp loop_2_done

    loop_done:
      mov r12, 0
      inc rcx
      jmp loop
  
  done:
    mov rsp, rbp
    pop rbp
    ret


main:
  //Configuracao da Pilha
  configurando_pilha:
    push rbp
    mov rbp, rsp
    sub rsp, 64
  
  //Salvando na Pilha o nome dos arquivos
  input_output_arquivos:
    mov rax, [rsi + 8]
    mov [rsp + 0], rax
    mov rax, [rsi + 16]
    mov [rsp + 8], rax
  
  abrir_arqs:
    //Carrega o arquivo de input na pilha (rsp + 0)
    mov rdi, [rsp + 0] 
    lea rsi, [rip + modo_leitura]
    call fopen@plt
    mov [rsp + 0], rax

    //Carrega o arquivo de output na pilha (rsp + 8)
    mov rdi, [rsp + 8]
    lea rsi, [rip + modo_escrita]
    call fopen@plt
    mov [rsp + 8], rax  
  
  ler_num_entradas:
    mov rdi, [rsp + 0]
    lea rsi, [rip + leitura_dec]
    lea rdx, [rsp + 16]
    call fscanf@plt
    
  
  ler_entradas_init:
    mov rcx, 0

  ler_entradas:
    cmp rcx, [rsp + 16]
    je done_main
    mov [rsp + 24], rcx
    
    ler_n:
      mov rdi, [rsp + 0]
      lea rsi, [rip + leitura_dec]
      lea rdx, [rsp + 32]
      call fscanf@plt

      //alocando dinamicamente o vetor
      mov rax, [rsp + 32]
      mov r9, 8
      mul r9
      mov rdi, rax
      call malloc@plt
      mov [rip + vetor], rax
    
    loop_vetor_init:
      mov r12, 0

    loop_vetor:
      cmp r12, [rsp + 32]
      je ordenar
      mov [rsp + 40], r12

      //Lendo elemento
      mov rdi, [rsp + 0]
      lea rsi, [rip + leitura_dec]
      lea rdx, [rsp + 48]
      call fscanf@plt
      mov r12, [rsp + 40]

      // inserir [rsp + 48] no vetor
      mov rsi, [rip + vetor]
      mov rax, [rsp + 48]
      mov [rsi + r12 * 8], rax

      inc r12
      jmp loop_vetor

    ordenar:
      mov rdi, [rip + vetor]
      mov rsi, [rsp + 32]
      dec rsi
      call bubblesort
      jmp output
    
    output:
      loop_output_init:
        mov rdi, [rsp + 8]
        lea rsi, [rip + str_output]
        mov rdx, [rsp + 24]        
        call fprintf@plt
        mov r8, 0

      loop_output:
        cmp r8, [rsp + 32]
        je continue
        mov [rsp + 56], r8
        mov rdi, [rsp + 8]
        lea rsi, [rip + print_dec]
        mov rdx, [rip + vetor]        
        mov rdx, [rdx + r8 * 8]
        call fprintf@plt
        mov r8, [rsp + 56]
        inc r8
        jmp loop_output
        
    
    continue:
      mov rdi, [rip + vetor]
      call free@plt
      mov rcx, [rsp + 24]
      inc rcx
      jmp ler_entradas

  
  //Encerrando a Main
  done_main:
    fechar_arqs:
      //Fechar o arquivo de input
      mov rdi, [rsp + 0]
      call fclose@plt
  
      //Fechar o arquivo de output
      mov rdi, [rsp + 8]
      call fclose@plt 

    //mov rdi, [rip + vetor]
    //call free@plt
    xor rax, rax
    mov rsp, rbp
    pop rbp
    ret
    
.section .bss
vetor:
  .8byte
  
n:
  .8byte
  
.section .data
modo_leitura:
  .string "r"

modo_escrita:
  .string "w"

leitura_dec:
  .string "%ld"

print_dec:
  .string " %ld"

str_output:
  .string "\n[%ld]"
