.model tiny
	;.STACK 100h

	locals
	.DATA
		mensbienv db 'Programa que calcula el error de Humming entre dos numeros de 16 bits$',0
		mensres db 'La cantidad de bits diferentes es: $',0
		mensfin db 'Fin del programa!$',0
		menstest db 'aqui$',0

	.CODE
		org 100h
		Principal PROC 
			;mov ax,@data
			;mov ds,ax
			mov sp,0fffh ; inicializar SP (Stack Pointer)

			;mov dx,offset mensbienv
			;call puts	
			
			mov bx,0cc33h	;dato no.1.
			mov dx,33cch	;dato no.2.

			;mov si,bx 	;copia dato 1
			;mov di,dx 	;copia dato 2
			
			push bx 
			push dx

			mov ax,bx
			mov bx,2
			call printNumBase

			mov dl,10
			call putchar

			mov dl,13
			call putchar
			
			pop dx
			mov ax,dx
			call printNumBase

			pop bx
			xor bx,dx

			mov ax,0
			mov cx,16
			@@ROTACION:
			ror bx,1
			jc @@INCERROR
			loop @@ROTACION
			jmp @@FINPROG
			@@INCERROR:
			inc ax			
			;dec cx
			loop @@ROTACION
			@@FINPROG:
			mov dl,10
			call putchar

			mov dl,13
			call putchar

			mov bx,10
			call printNumBase
			;Siempre se pone
			;mov 	ax,4C00h
			;int 	21h
			@@FIN:
			jmp @@FIN
		ENDP
;============================PROCEDIMIENTOS=======================
		putchar PROC
			push ax
			
			mov ah,02h
			int 21h

			pop ax
			ret
		ENDP

		puts PROC 
			push ax
			
			mov ah,09h
			int 21h

			pop ax
			ret
		ENDP 

		printNumBase PROC
			push ax
			push bx
			push cx
			push dx
			;donde se le va a meter la base
			;mov 	bx,2

			;aqui se va a meter en numero
			;mov 	ax,8
			;inicializar cx en 0
			mov 	cx,0
			
			@@division:
				;residuo debe estar en 0
				mov 	dx,0
				;div usa 'ax' y lo divide entre lo que pongas en div
				div 	bx
				;se mete el 'dx' (residuo) a la pila
				push 	dx
				;incrementar las veces que se hace la division
				inc 	cx
				cmp 	ax,0
				jne 	@@division
			
			@@sacarPila:
				;sacar de pila
				pop 	dx
				;interrupcion que imprime
				mov 	ah,02h
				;se mueve dl a dh
				mov 	dh,dl
				;compara dh con 9
				cmp 	dh,9
				;brinca a @@menor si es menor o igual a 9
				jbe 	@@menor
					;agrega 37h a dh
					add 	dh,37h
					;brinca a fin
					jmp 	@@fin
				@@menor:
					;agrega a dh 30h
					add		dh,30h
				@@fin:
					;se mueve dh a dl para imprimir
					mov 	dl,dh
				;imprime
				int 	21h
				;decrementa en 1 a cx
				dec		cx
				;compara con 0
				cmp 	cx,0
			;loop a @@sacarPila  si cx no es igual a 0
			jne 	@@sacarPila
			pop dx
			pop cx
			pop bx
			pop ax
		ret 
		ENDP
	END principal
