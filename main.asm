; ProjetoFinal.asm
;
; Author : Lucas Leite Tavares RA:156377
;          Deivit Bonach       RA:166508

.cseg
	.org 0x0000   ; A partir de 0x0000, temos o vetor de interrupção.
	rjmp reset
	.org 0x0002   ; Endereço da rotina de interrupção associada a INT0.
	rjmp INT0_vetor
	.org 0x0034   ; O vetor de interrupção finaliza em 0x0034, e a partir desta posição se inicia a escrita do programa principal.

reset:		
	sbi DDRB,5	  ; Esta é a configuração de GPIO.
	; Setando o bit 5 "DDB5", no registrador DDRB, configuramos o pino PB5 "led" como output.

	lds r16,EICRA ; Configuração de interrupção para borda de subida.
	ori r16,0x03
	sts EICRA,r16

	in r16,EIMSK  ; Habilita a interrupção proveniente de INT0.
	ori r16,0x01
	out EIMSK,r16

	ldi r17,0x01  ; Carrega o valor referente ao estado 1 "1 segundo" em r17.
	sei

main:
    cpi r17,0x01  ; Treixo para verificar se o estado atual é "1 segundo",
	brne b        ; se for igual, a rotina de atraso para "1 segundo" é executada, se não, o próximo estado é verificado.
	ldi r20,$1F   ; O registrador r20 é associado a rotina de atraso, para $1F temos um atraso muito próximo de 1 segundo.
	rjmp loop

b:  cpi r17,0x02  ; Treixo para verificar se o estado atual é "0,5 segundos".
	brne c        ; Se for igual a rotina é executada, se não o próximo estado é verificado.
	ldi r20,$0F   ; O registrador r20 é atualizado para $0F, que corresponde a um atraso próxino de 0,5 segundos.
	rjmp loop

c:  cpi r17,0x03  ; Treixo para verificar se o estado atual é "0,25 segundos".
	brne d        ; Se for igual a rotina é executada, se não o programa retorna para a main.
	ldi r20,$08   ; O registrador r20 é atualizado para $08, que corresponde a um atraso próximo de 0,25 segundos.
	ldi r17,0x00  /* Como este é o último estado, r17 é atualizado para zero, pois na próxima interrupção ele será incrementado, 
					 e o programa retornará ao estádo inicial.*/
	rjmp loop

d:  rjmp main

loop:             ; Este loop é reponsável por realizar a permuta entre "acesso" e "apagado".
	sbi PORTB,5   ; Como PB5 está configurado como output, setando o bit referente a PB5 em PORTB, configuramos esta output como nível alto
	call atraso
	cbi PORTB,5   ; Neste caso PB5 é configurado como nível baixo.
	call atraso
	rjmp loop
		
INT0_vetor:
	break
	in r13,SREG
	inc r17       ; Sempre que ocorre uma interrupção o vetor é responsavel apenas por alterar o estado.

	ldi r16, high(RAMEND) ; Este conjunto de códigos tem a finalizade de reinicializar o ponteiro
	out SPH, r16          ; da pilha, retornando o Stack Pointer a posição inicial "0x08FF".
	ldi r16, low(RAMEND)
	out SPL, r16

	out SREG,r13
	sei
	rjmp main     ; E a interrupção ao invés de voltar para onde o programa foi interrompido, ela retorna para a main.

atraso:        ; Rotina de atraso desenvolvida no terceira atividade.
	ldi r23,$0   ; Nossa flag de parada do programa
	call loop0   ; Primeiro loop
	ret          ; Retorna para o tratamento do led

	loop0:
		ldi r21,$0   ; Carrega o registrador do proximo loop
		call loop1   ; Chamada do segundo loop
		inc r23      ; Incrementa a flag de parada
		cp r20,r23   ; Compara com a entrada
		brne loop0   ; Desvio de parada
		ret          ; Retorna para o final

		loop1:
			ldi r22,$0   ; Carrega o registrador do proximo loop
			inc r21      ; Incrementa a flag de parada do loop1
			call loop2   ; Chama o terceiro loop
			cpi r21,$FF  ; Limite de parada em 255 decimal
			brne loop1   ; Desvio de parada
			ret          ; Retorna para o loop anterior

			loop2:
				inc r22     ; Incrementa a a flag de parada do loop2
				cpi r22,$FF ; Limite de parada em 255 decimal
				brne loop2  ; Desvio de parada
				ret         ; Retorna ao loop anterior
		
