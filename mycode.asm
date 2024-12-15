
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

org 100h

.model small                   
.stack 1000h
.data
 
    number      db  150d             
 
   
    CR          equ 13d
    LF          equ 10d
 
    
    instruction db  CR, LF, 'Please enter a valid number between 1 and 255 : $'
    lessValue   db  CR, LF, 'The number is SMALLER than your guess','$'
    moreValue   db  CR, LF, 'The number is BIGGER than your guess', '$'
    equalValue  db  CR, LF, 'You have made fine Guess!', '$'
    
    errorMsg    db  CR, LF, 'Error - The number is out of range!', '$'
    retry       db  CR, LF, 'Retry [y/n] ? ' ,'$'
 
    guessNum    db  0d             
    errorCHeck  db  0d              
 
.code
 
start:
    
    MOV AX, 0h
    MOV BX, 0h
    MOV CX, 0h
    MOV DX, 0h
 
    MOV BX, OFFSET guessNum         
    MOV BYTE PTR [BX], 0d           
 
    MOV BX, OFFSET errorCheck       
    MOV BYTE PTR [BX], 0d           
    
 
    MOV AX, @data                   
    MOV DS, AX                       
    MOV DX, offset instruction      
 
    MOV AH, 9h                      
    INT 21h
    
    MOV CL, 0h                      
    MOV DX, 0h                      
    

while:
                                    
    CMP     CL, 3d                 
    
    MOV     AH, 1h                  
    INT     21h                    
    
    CMP     AL, 0DH                 
    JE      endwhile                      

    SUB     AL, 30h                
    MOV     DL, AL                 
    PUSH    DX                      
    INC     CL                     
 
    JMP while
                               
 
endwhile:

 
    DEC CL                         
    
    CMP CL, 02h                   
    JG  ifError                     
 
    MOV BX, OFFSET errorCHeck       
    MOV BYTE PTR [BX], CL           
 
    MOV CL, 0h                      
 

while2:
 
    CMP CL,errorCheck
    JG endwhile2
 
    POP DX                          
 
    MOV CH, 0h                      
    MOV AL, 1d                      
    MOV DH, 10d                     
 

 while3:
 
    CMP CH, CL                      
    JGE endwhile3                   
 
    MUL DH                          
 
    INC CH                         
    JMP while3
 
 endwhile3:
 
 
    MUL DL                         
 
    JO  ifError                     
 
    MOV DL, AL                      
    ADD DL, guessNum                
 
    JC  ifError                     
 
    MOV BX, OFFSET guessNum         
    MOV BYTE PTR [BX], DL          
 
    INC CL                         
 
    JMP while2                      
 
endwhile2:
 
    MOV AX, @data                  
    MOV DS, AX                      
    
    MOV DL, number                 
    MOV DH, guessNum               
    
    CMP DH, DL                     
 
    JC ifGreater                   
    JE ifEqual                     
    JG ifLower                     
 
ifEqual:
    
    MOV DX, offset equalValue      
    MOV AH, 9h                      
    INT 21h                         
    JMP exit                        
 
ifGreater:
    
    MOV DX, offset moreVALue        
    MOV AH, 9h                     
    INT 21h                        
    JMP start                       
 
ifLower:
    
    MOV DX, offset lessValue       
    MOV AH, 9h                     
    INT 21h                        
    JMP start                      
 
ifError:
    
    MOV DX, offset errorMsg        
    MOV AH, 9h                      
    INT 21h                        
    JMP start                            
 
exit:
 
retry_while:
 
    MOV DX, offset retry            
 
    MOV AH, 9h                     
    INT 21h                        
 
    MOV AH, 1h                    
    INT 21h                        
 
    CMP AL, 6Eh                     
    JE return_to_DOS                
 
    CMP AL, 79h                    
    JE restart                      
                                   
 
    JMP retry_while                   
 
retry_endwhile:
 
restart:
    JMP start                       
    
return_to_DOS:
    MOV AX, 4c00h                   
    INT 21h                         
    end start
 
RET

ret

ret




