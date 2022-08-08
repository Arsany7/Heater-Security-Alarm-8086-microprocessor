; set data segment to code segment:
org  100h

.data

a     dw    0ah,0dh,"Please enter the reading of the thermometer :$" 

g     dw    0ah,0dh,"GREEN LED ON$"

y     dw    0ah,0dh,"YELLOW LED ON$"

r     dw    0ah,0dh,"RED LED ON$"
.code
main proc
              
      mov ax,@data
      mov ds,ax
      repee:
      mov  cx,00FFh
      mov  bx,01FDH  
      lea  dx,a
      mov  ah,09h  
      int  21h     
      mov  cx,0
      call InputNo
      cmp  dx, 200
      jle  green
      cmp  dx, 500
      jl   yellow
      jge  red
      green:
      lea  dx,g
      mov  ah,09h  
      int  21h
      jmp  ok
      yellow:
      lea  dx,y
      mov  ah,09h  
      int  21h 
      jmp  ok
      red:
      lea  dx,r
      mov  ah,09h
      int  21h 
      ok:
      mov cx,00FFh   
      Back: 
      Dec cx
      jnz back
      dec bx
      jnz repee
      
        
ViewNo: 
      push ax ;we will push ax and dx to the stack because we will change there values while viewing then we will pop them back from
      push dx ;the stack we will do these so, we don't affect their contents
      mov dx,ax ;we will mov the value to dx as interrupt 21h expect that the output is stored in it
      add dl,30h ;add 30 to its value to convert it back to ascii
      mov ah,2
      int 21h
      pop dx  
      pop ax
      ret  
      
      
InputNo:  
      mov ah,0
      int 16h ;then we will use int 16h to read a key press     
      mov dx,0  
      mov bx,1 
      cmp al,0dh ;the keypress will be stored in al so, we will comapre to  0d which represent the enter key, to know wheter he finished entering the number or not 
      je FormNo ;if it's the enter key then this mean we already have our number stored in the stack, so we will return it back using FormNo
      sub ax,30h ;we will subtract 30 from the the value of ax to convert the value of key press from ascii to decimal
      call ViewNo ;then call ViewNo to view the key we pressed on the screen
      mov ah,0 ;we will mov 0 to ah before we push ax to the stack bec we only need the value in al
      push ax  ;push the contents of ax to the stack
      inc cx   ;we will add 1 to cx as this represent the counter for the number of digit
      jmp InputNo ;then we will jump back to input number to either take another number or press enter          
  
  
;we took each number separatly so we need to form our number and store in one bit for example if our number 235
FormNo:
      pop ax  
      push dx      
      mul bx
      pop dx
      add dx,ax
      mov ax,bx       
      mov bx,10
      push dx
      mul bx
      pop dx
      mov bx,ax
      dec cx
      cmp cx,0
      jne FormNo
      ret       
      main endp
end   main