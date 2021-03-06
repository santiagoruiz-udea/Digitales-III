; Include derivative-specific definitions
            INCLUDE 'derivative.inc'
         
;
; Export symbols
;
            	 XDEF _Startup
            	 ABSENTRY _Startup
            	 
Mask_operator:   EQU	%00000011

; ----------------------------------------------------------------------------------------------
; -------------- Section to define variables in RAM, inside the zero page ---------------------
; ----------------------------------------------------------------------------------------------
                ORG    Z_RAMStart
; ---------------- Variables ----------------

OperandA:        DS.B   1           ; Contador
OperandB:        DS.B   1 
Operator:        DS.B   1
Result:        	 DS.B   1

; ----------------------------------------------------------------------------------------------
; -------------- Section to define variables in RAM, outside the zero page ---------------------
; ----------------------------------------------------------------------------------------------
            ORG    RAMStart

; Secci?n de c?digo del programa. 
		ORG   ROMStart
 _Startup:
		; Power off WatchDOG
		LDA   #$20
		STA   SOPT1
		
		; Define stack beginning (Last RAM position)
		LDHX #RAMEnd+1
		TXS 		    
		
		; Limpiar Registros
		CLRA
		CLRX
		CLRH
		CLR OperandA
		CLR OperandB
		CLR Operator
		CLR Result

		MOV #$00,PTAD		; Port to get 
		MOV #$F8,PTADD		; P0 - Get Op.1, P1 - Get Op.2, P2 - Start
		MOV #$00,PTBD		; Port to get the operands
		MOV #$00, PTBDD
		MOV #$00,PTCD       ; Port to show the result
		MOV #$FF, PTCDD
		MOV #$00,PTDD       ; Port to show the results flags
		MOV #$03, PTDDD
		
; Body program
Wait: 	BRCLR   0,PTAD, Debounce
		BRCLR   1,PTAD, Debounce
		BRCLR   2,PTAD, Debounce
		BRA     Wait
		
Debounce:	LDHX #5000

Delay:		AIX  #-1
			CPHX #0
			BNE	 Delay	
			
			BRCLR 0,PTAD, Capture_Op_A
			BRCLR 1,PTAD, Capture_Op_B
			BRCLR 2,PTAD, Start_operation
			
Capture_Op_A:	MOV	PTBD, OperandA
				BRA	Wait

Capture_Op_B:	MOV	PTBD, OperandB
				BRA	Wait

Start_operation: MOV PTBD, Operator
				 LDA Operator
				 AND #Mask_operator
				 CMP #0
				 BNE Adition
				 CMP #1
				 BNE Substraction
				 CMP #2
				 BNE Multiplication
				 BNA Division

Here:       BRA  Here

;Adition:


;Substraction:


;Multiplication:


;Division:			 
				 

;*                 Interrupt Vectors                          *
;**************************************************************

            ORG	$FFFE

			

			
			DC.W  _Startup			; Reset
