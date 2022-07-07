include	Irvine32.inc
includelib Irvine32.lib


cout macro text
local string
.data
string byte text,0
.code

mov edx, offset string
call writestring

endm

;/////////////// .data /////////////////
.data
;////////////// name & score & moves /////////////////
playername byte 20 DUP("$")
score byte 0
moves byte 15


;//////////// BOARD 1//////////////
Table1 Dword 10 dup (0)
;rowsize = ($-Table1)
	Dword	10 dup (0)
	Dword	10 dup (0)
	Dword	10 dup (0)
	Dword	10 dup (0)
	Dword	10 dup (0)
	Dword	10 dup (0)
	Dword	10 dup (0)
	Dword	10 dup (0)
	Dword	10 dup (0)
space byte "    ",0
rowspaces byte "                  ",0
blastnum dword 0
;/////////////////////////////////
small_lines byte "              -------|--------|--------|--------|--------|--------|--------|--------|--------|--------|------",0
vertical_line byte "  | ",0
;///////////////////////////////////
;//////////// BOARD 2 /////////////
Table2 Dword 10 dup (0)
rowsize=($-Table2)
	Dword	10 dup (0)
	Dword	10 dup (0)
	Dword	10 dup (0)
	Dword	10 dup (0)
	Dword	10 dup (0)
	Dword	10 dup (0)
	Dword	10 dup (0)
	Dword	10 dup (0)
	Dword	10 dup (0)
minispace byte " ",0
lines byte "                                       |--------|--------|--------|--------|",0
detectzero byte 0
zerospace byte "    ",0
notswapmsg byte "You can swap only with adjacent rows or cols",0

;count to print small lines in level 2
count Byte 0

;/////////// USER INPUT ///////////
enterrow1 byte "Enter 1st number row: ",0
entercol1 byte "Enter 1st number col: ",0
Row1 Dword ? 
Col1 Dword ? 

enterrow2 byte "Enter 2nd number row: ",0
entercol2 byte "Enter 2nd number col: ",0
Row2 Dword ?
Col2 Dword ?
;/////////////////////////////////////////////////////////


;variables for crushing functionality
count1 DWORD 0		;counting similar numbers
count2 DWORD 0		;index from where crushing will start

;////////////////////// .Code ///////////////////////////
.code

;//////////////// main prodecure ///////////////

main PROC

	cout"Enter player name: "
	call inputplayer
	call clrscr
;	call populateBoard1
;	call checkRow
;	call checkColumn
;	mov score,0
;;mov ecx,10
;level1:
;;push ecx
;mov ecx,10
;	call displayplayer	
;	call PrintTable1
;	call crlf
;	mov ecx,10
;	call userinput
;	mov ecx,10
;	call crlf
;	mov ecx,10
;	call swap1
;	mov ecx,10
;	sub moves,1
;	mov ecx,10
;	call checkRow
;	mov ecx,10
;	call checkColumn
;	mov ecx,10
;	call clrscr
;	mov ecx,10
;	cmp moves,0
;	je level1end
;
;loop level1
;
;;/////////////////////////////////////////
;	level1end:
;	mov score,0
;	mov moves,15
;
;/////////////// Level-2 ////////////////
;///////////////////////////////////////
	call populateBoard2
	call checkRow2
	call checkColumn2
	mov score,0
level2:
	call displayplayer	
	call printtable2
	call crlf
	mov ecx,10
	call userinput
	mov ecx,10
	call crlf
	mov ecx,10
	call swaplevel2
	call swap1
	mov ecx,10
	sub moves,1
	mov ecx,10
	call checkRow
	mov ecx,10
	call checkColumn
	mov ecx,10
	call clrscr
	mov ecx,10
	cmp moves,0
	je level2end

loop level2

level2end:

;	call checkRow
;	call crlf
;	call crlf
;	call PrintTable1
;	call checkColumn
;	call crlf
;	call crlf
;	call PrintTable1
;	;call PrintTable2
;	call crlf
;	call crlf
;	;call checkColumn
;	call populateBoard3
;	call PrintTable3
;	call crlf
;	call crlf
;	call userinput
;	call crlf
;	call crlf
;	call swap
;	call crlf
;	call crlf
;	call PrintTable3
	;/////////////////////////
	;call populateboard2
	;call printtable2
	exit
main ENDP

;////////////////// input player name /////////////////
inputplayer proc
mov ecx,20
mov edx,offset playername
call readString

ret
inputplayer endp
;////////////////// Display player name,Score,Moves ///
displayplayer proc
cout"Name: "
mov edx,offset playername
call writeString
cout"            Score: "
mov al, score
call writeDec
cout"            Moves: "
mov al,moves
call writeDec

ret
displayplayer endp

;////////////////// input procedure //////////////////
 userinput proc

	Mov edx,offset enterrow1
	call writestring
	call readdec
	Mov Row1,eax
	Mov edx,offset entercol1
	call writestring
	call readdec
	Mov Col1,eax

	Mov edx,offset enterrow2
	call writestring
	call readdec
	Mov Row2,eax
	Mov edx,offset entercol2
	call writestring
	call readdec
	Mov Col2,eax

	ret
 userinput endp

  ;////////////////////// SWAP INDEX-level-1 //////////////////

 swap proc
	 
	L1:
		push eax
		mov eax,Row1
		cmp eax,Row2
		pop eax
		JNE L3	

	L2:
		push edx 
		mov edx, Col1
		inc edx
		cmp Col2,edx
		pop edx
		JNE L3
		jmp SWAPS

	L3:
		push eax
		mov eax,Col1
		cmp eax,Col2
		pop eax
		JNE notswap	
	
	L4:
		push edx 
		mov edx, Row1
		inc edx
		cmp Row2,edx
		pop edx
		JE SWAPS 

	notswap:
		push edx 
		mov edx,offset notswapmsg
		call Crlf
		call WriteString
		call Crlf
		call Crlf
		pop edx
		jmp Done

	SWAPS:
		Mov ebx,offset Table1
		mov eax,rowsize
		mul Row1
		Mov ebx, eax
		mov esi,Col1
		Mov eax,Table1[ebx+esi*Type Table1]
		cmp eax, 88
		JE Xcondition
		push eax

		Mov edx,offset Table1
		mov eax,rowsize
		Mul Row2
		mov edx, eax
		mov edi,Col2
		Mov ecx,Table1[edx+edi*Type Table1]
		cmp eax, 88
		JE Xcondition
		pop eax

		Mov Table1[ebx+esi*Type Table1],ecx
		Mov Table1[edx+edi*Type Table1],eax
		JMP Done
  Xcondition:
		cout "You can't swap with blockers"
  Done:
	ret
swap endp
;////////////////////////////////////////////////////////

;////////////////////// SWAP INDEX-level-2 //////////////////

 swaplevel2 proc
	 
	L1:
		push eax
		mov eax,Row1
		cmp eax,Row2
		pop eax
		JNE L3	

	L2:
		push edx 
		mov edx, Col1
		inc edx
		cmp Col2,edx
		pop edx
		JNE L3
		jmp SWAPS

	L3:
		push eax
		mov eax,Col1
		cmp eax,Col2
		pop eax
		JNE notswap	
	
	L4:
		push edx 
		mov edx, Row1
		inc edx
		cmp Row2,edx
		pop edx
		JE SWAPS 

	notswap:
		push edx 
		mov edx,offset notswapmsg
		call Crlf
		call WriteString
		call Crlf
		call Crlf
		pop edx
		jmp Done

	SWAPS:
		Mov ebx,offset Table2
		mov eax,rowsize
		mul Row1
		Mov ebx, eax
		mov esi,Col1
		Mov eax,Table2[ebx+esi*Type Table2]
		cmp eax, 88
		JE Xcondition
		push eax

		Mov edx,offset Table2
		mov eax,rowsize
		Mul Row2
		mov edx, eax
		mov edi,Col2
		Mov ecx,Table2[edx+edi*Type Table2]
		cmp eax, 88
		JE Xcondition
		pop eax

		Mov Table2[ebx+esi*Type Table2],ecx
		Mov Table2[edx+edi*Type Table2],eax
		JMP Done
  Xcondition:
		cout "You can't swap with blockers"
  Done:
	ret
swaplevel2 endp

 ;/////////////////// Boom Swap //////////////////////////
 swap1 proc
	 
	L1:
		push eax
		mov eax,Row1
		cmp eax,Row2
		pop eax
		JNE L3	

	L2:
		push edx 
		mov edx, Col1
		inc edx
		cmp Col2,edx
		pop edx
		JNE L3
		jmp SWAPS

	L3:
		push eax
		mov eax,Col1
		cmp eax,Col2
		pop eax
		JNE notswap	
	
	L4:
		push edx 
		mov edx, Row1
		inc edx
		cmp Row2,edx
		pop edx
		JE SWAPS 

	notswap:
		push edx 
		mov edx,offset notswapmsg
		call Crlf
		call WriteString
		call Crlf
		call Crlf
		pop edx
		jmp Done

	SWAPS:
		Mov ebx,offset Table1
		mov eax,rowsize
		mul Row1
		Mov ebx, eax
		mov esi,Col1
		Mov eax,Table1[ebx+esi*Type Table1]
		push eax

		Mov edx,offset Table1
		mov eax,rowsize
		Mul Row2
		mov edx, eax
		mov edi,Col2
		Mov ecx,Table1[edx+edi*Type Table1]
		pop eax

		Mov Table1[ebx+esi*Type Table1],ecx
		Mov Table1[edx+edi*Type Table1],eax
		cmp ecx,66
		je Bcondition
		cmp eax,66
		je Bcondition1
		JMP Done
  Bcondition:
		mov blastnum,eax
		call Boomm
		jmp Done
  Bcondition1:
		mov blastnum,ecx
		call Boomm
  Done:
	ret
swap1 endp

 ;////////////////////////////////////////////////////////
 Boomm proc uses eax ecx

	Mov ecx,10
	Mov ebx,0
	Mov esi,0
	
Label3:
	push ecx
	Mov ecx,10
	Mov esi,0
	Label4:	
	mov eax, Table2[ebx+esi]
	cmp eax,blastnum
	je blast1

	add esi, type Table2
	Loop Label4

	pop ecx
	add ebx, rowsize
	
	Loop Label3
	jmp Done
blast1:
	mov eax ,4
	call randomrange
	add score,1
	inc eax
	mov  Table2[ebx+esi], eax
	add esi, type Table2
	dec ecx
	jmp Label4

	Done:
	ret	
 Boomm endp

 ;////////////////////////////////////////////////////////

populateBoard1 Proc
	
	Mov ecx,10
	Mov ebx,0
	Mov esi,0
	
	
Label1:
	push ecx
	Mov ecx,10
	Mov esi,0
	
	Label2:		
		Mov eax,5		; Random Number Range (0-5)
		call randomRange
		inc eax			; Add 1 for range (1-5)
		mov Table1[ebx+esi], eax
		mov eax,0
		add esi,type Table1 
	Loop Label2
		pop ecx
		add ebx, rowsize
Loop Label1
ret
populateBoard1 endp

;/////////////////// populateboard2 //////////////////////
 populateboard2 proc
 Mov ecx,10
	Mov ebx,0
	Mov esi,0
	
	
Label1:
	push ecx
	Mov ecx,10
	Mov esi,0
	
	Label2:		
		Mov eax,6		; Random Number Range (0-5)
		call randomRange
		inc eax			; Add 1 for range (1-5)
		cmp eax,6
		je make66
		mov Table2[ebx+esi], eax
		jmp makezeros
		make66:
		mov Table2[ebx+esi], 66
		makezeros:
		mov eax,0
		add esi,type Table2 
	Loop Label2
		pop ecx
		add ebx, rowsize
Loop Label1

;////////// making plus board //////////
Mov ecx,10
	Mov ebx,0
	Mov esi,0
	Mov eax,0
	Mov edx,0

Label11:
	push ecx
	mov ecx,10
	mov esi,0
	Label12:
	;(i<=2&&j<=2)
	cmp eax,3
	jb condition1
	jmp othercondition1
	condition1:
	cmp edx,3
	jb makezero

othercondition1:
	;(i<3&&j>6)
	cmp eax,3		
	jb condition2
	jmp othercondition2	;if i is not less than 3
	condition2:
	cmp edx,6
	ja makezero

othercondition2:
	;(i>3&&i<6)
	;(j>=3&&j<=6)
	cmp eax,3
	ja condition3
	jmp othercondition3 ; if not
	condition3:
	cmp eax,6
	jb condition4
	jmp othercondition3
	condition4:
	cmp edx,3
	jae condition5
	jmp othercondition3
	condition5:
	cmp edx,6
	jbe makezero

othercondition3:
	;(i>6&& j<3)
	cmp eax,6
	ja condition6
	jmp othercondition4
	condition6:
	cmp edx,3
	jb makezero
othercondition4:
;(i>6&&j>6)
cmp eax,6
ja condition7
jmp again
condition7:
cmp edx,6
ja makezero

	again:
	inc edx
	add esi,type Table2
	jmp nextiteration

	

	makezero:
	mov Table2[ebx+esi], 0

	jmp again
	nextiteration:
	Loop Label12

	mov edx,0
	inc eax
	pop ecx
	add ebx,rowsize
Loop Label11

 ret
 populateboard2 endp
;/////////////////////////////////////////////////////////
;/////////////////// Print table 1 //////////////////////

;========================================
; Sets different colors for different values
color_board proc
	cmp eax,1 
	je rad
	cmp eax,2 
	je bron
	cmp eax,66
	je gra
	cmp eax,3 
	je gren
	cmp eax,4 
	je blu
	cmp eax,5 
	je litmag
	
	cmp eax,88
	je obstacle


	rad:
	mov eax, red
	call settextcolor
	ret
	bron:
	mov eax, brown
	call settextcolor
	ret
	gren:
	mov eax, lightgreen
	call settextcolor
	ret
	blu:
	mov eax, blue
	call settextcolor
	ret
	litmag:
	mov eax, lightmagenta
	call settextcolor
	ret
	gra:
	mov eax, gray
	call settextcolor
	ret
	obstacle:
	mov eax,yellow+(blue*16)
	call settextcolor
ret
color_board endp
;========================================
PrintTable1 Proc	
	Mov ecx,10
	Mov ebx,0
	Mov esi,0
	
Label3:
	push ecx
	Mov ecx,10
	Mov esi,0

	call crlf
	mov edx, offset rowspaces
	call WriteString

	Label4:	
	mov eax, Table1[ebx+esi]
	push eax 
	call color_board  ; for coloring board
	pop eax
	call WriteDec

	mov eax, lightblue
	call settextcolor
	mov edx, offset vertical_line
	call WriteString
	mov edx, offset space
	call WriteString

	add esi, type Table1
	Loop Label4
	call crlf

	pop ecx
	add ebx, rowsize
	mov eax, lightcyan
	call settextcolor
	mov edx, offset small_lines
	call WriteString
	Loop Label3
ret
PrintTable1 endp

;=================================================;
;//////////////////////////////////////////////////
;/////////////// print table2 ////////////////////
 printtable2 proc

	Mov ecx,10
	Mov ebx,0
	Mov esi,0
	Mov count,0

Label3:
	push ecx
	Mov ecx,10
	Mov esi,0

	call label14_proc

		pop ecx
		add ebx, rowsize
		mov eax, lightcyan
	    call settextcolor

		cmp count,3
		jae condition2
		jmp printsmalllines
		condition2:
		cmp count,6
		jbe printbiglines
		jmp printsmalllines
		printbiglines:
		mov edx, offset small_lines
		call WriteString
		jmp incrementcount

		printsmalllines:
		mov edx, offset lines
		call WriteString

		incrementcount:
		inc count
Loop Label3
 ret
 printtable2 endp
;///////////////////////////////////////////////
label14_proc proc
 	call crlf
	mov edx, offset rowspaces
		call WriteString
 		Label4:			
	mov eax, Table2[ebx+esi]
		cmp eax,0
		je skip
		push eax
		call color_board
		pop eax
		cmp eax,66
		je printB
		call WriteDec
		jmp noskip
		printB:
		call Writechar
		jmp noskip
		skip:
		mov edx, offset minispace
		call WriteString
		noskip:
		mov eax, lightblue
		call settextcolor
		
		mov edx, offset vertical_line
		call WriteString
		
		mov edx, offset space
		call WriteString
		
		add esi, type Table2
	Loop Label4
			call crlf
			ret
 label14_proc endp
;=====================================================

;/////////////////////////////////////////////////////
;///////////////// populate board 3 /////////////////

populateBoard3 proc
Mov ecx,10
	Mov ebx,0
	Mov esi,0
	
	
Label1:
	push ecx
	Mov ecx,10
	Mov esi,0
	
	Label2:		
		Mov eax,6		; Random Number Range (0-5)
		call randomRange
		inc eax			; Add 1 for range (1-5)
		cmp eax,6
		je make88
		mov Table1[ebx+esi], eax
		jmp makezeros
		make88:
		mov Table1[ebx+esi], 88		; ascii of 'X'
		makezeros:
		mov eax,0
		add esi,type Table1 
	Loop Label2
		pop ecx
		add ebx, rowsize
Loop Label1
ret
populateBoard3 endp
;///////////////////////////////////////////////////

;/////////////////////////////////////////////////
;//////////////// print board 3 /////////////////

printTable3 proc
Mov ecx,10
	Mov ebx,0
	Mov esi,0
	
Label3:
	push ecx
	Mov ecx,10
	Mov esi,0

	call crlf
	mov edx, offset rowspaces
	call WriteString

	Label4:	
	mov eax, Table1[ebx+esi]
	push eax 
	call color_board  ; for coloring board()
	pop eax
	cmp eax,88
	je printX

	call WriteDec
	jmp continue
	printX:
	call Writechar
	continue:
	mov eax, lightblue
	call settextcolor
	mov edx, offset vertical_line
	call WriteString
	mov edx, offset space
	call WriteString

	add esi, type Table1
	Loop Label4
	call crlf

	pop ecx
	add ebx, rowsize
	mov eax, lightcyan
	call settextcolor
	mov edx, offset small_lines
	call WriteString
	Loop Label3
ret
printTable3 endp

;////////////////// row crushing-level-1 ////////////////////////
checkRow PROC

	pusha

	mov count1,0
	mov count2,0

	mov ecx,10
	mov ebx,0
	mov esi,0

	rowTraverse:
		push ecx
		mov ecx,9
		mov esi,0

		colTraverse:
			;Comparing two consecutive indexes
			mov eax,0
			cmp eax,Table1[ebx+esi]
			JE Next

			mov eax,Table1[ebx+esi]
			add esi,TYPE Table1
			cmp eax,Table1[ebx+esi]

			JE N1

			;Checking if 3 of them were similar
			mov eax,2
			cmp eax,count1
			JBE N3

			;If they are not similar set counts to 0
			mov eax,0
			mov count1,0
			mov count2,0

		Next:
		loop colTraverse

		pop ecx
		add ebx,rowsize
		mov eax,0
		mov count1,0
		mov count2,0
	loop rowTraverse

	JMP RowsCrushed

	;counting number of elements to crush
	N1:
		inc count1
		mov eax,count1
		cmp eax,1

		JE N2
		JMP Next

	;Storing index from where to start crushing
	N2:
		mov count2,esi
		sub count2,TYPE Table1
		JMP Next

	;Crushing numbers
	N3:
		push esi

		inc count1
		push ecx
		add score,3
		mov ecx,count1
		mov esi,count2

		N4:
			Mov eax,5		; Random Number Range (0-5)
			call randomRange
			inc eax			; Add 1 for range (1-5)
			mov Table1[ebx+esi], eax
			add esi,TYPE Table1
		Loop N4

		mov eax,0
		mov count1,0
		mov count2,0

		pop ecx
		pop esi

		call checkRow

		JMP Next

RowsCrushed:
	popa

ret 
checkRow endp
;/////////////////////////////////////////////////////

;////////////// column crushing-level-1 /////////////////////
checkColumn PROC

pusha

	mov count1,0
	mov count2,0

	mov ecx,10
	mov ebx,0
	mov esi,0

	colTraverse:
		push ecx
		mov ecx,9
		mov ebx,0

		rowTraverse:
			;Comparing two consecutive indexes

			mov eax,0
			cmp eax,Table1[ebx+esi]
			JE Next

			mov eax,Table1[ebx+esi]
			add ebx,rowsize
			cmp eax,Table1[ebx+esi]

			JE N1

			;Checking if 3 of them were similar
			mov eax,2
			cmp eax,count1
			JBE N3

			;If they are not similar set counts to 0
			mov eax,0
			mov count1,0
			mov count2,0

		Next:
		loop rowTraverse

		pop ecx
		add esi,type Table1
		mov eax,0
		mov count1,0
		mov count2,0
	loop colTraverse

	JMP colCrushed

	;counting number of elements to crush
	N1:
		inc count1
		mov eax,count1
		cmp eax,1

		JE N2
		JMP Next

	;Storing index from where to start crushing
	N2:
		mov count2,ebx
		sub count2,rowsize
		JMP Next

	;Crushing numbers
	N3:
		push ebx

		inc count1

		push ecx
		add score,3
		mov ecx,count1
		mov ebx,count2

		N4:
			Mov eax,5		; Random Number Range (0-5)
			call randomRange
			inc eax			; Add 1 for range (1-5)
			mov Table1[ebx+esi], eax
			add ebx,rowsize
		Loop N4

		mov eax,0
		mov count1,0
		mov count2,0

		pop ecx
		pop ebx

		call checkColumn

		JMP Next

colCrushed:
	popa
	ret 
checkColumn endp

;/////////////////////////////////////////////////////////////////////////////

;////////////////// row crushing level-2 ////////////////////////
checkRow2 PROC

	pusha

	mov count1,0
	mov count2,0

	mov ecx,10
	mov ebx,0
	mov esi,0

	rowTraverse:
		push ecx
		mov ecx,9
		mov esi,0

		colTraverse:
			;Comparing two consecutive indexes
			mov eax,0
			cmp eax,Table2[ebx+esi]
			JE Next

			mov eax,Table2[ebx+esi]
			add esi,TYPE Table2
			cmp eax,Table2[ebx+esi]

			JE N1

			;Checking if 3 of them were similar
			mov eax,2
			cmp eax,count1
			JBE N3

			;If they are not similar set counts to 0
			mov eax,0
			mov count1,0
			mov count2,0

		Next:
		loop colTraverse

		pop ecx
		add ebx,rowsize
		mov eax,0
		mov count1,0
		mov count2,0
	loop rowTraverse

	JMP RowsCrushed

	;counting number of elements to crush
	N1:
		inc count1
		mov eax,count1
		cmp eax,1

		JE N2
		JMP Next

	;Storing index from where to start crushing
	N2:
		mov count2,esi
		sub count2,TYPE Table2
		JMP Next

	;Crushing numbers
	N3:
		push esi

		inc count1
		push ecx
		add score,3
		mov ecx,count1
		mov esi,count2

		N4:
			Mov eax,5		; Random Number Range (0-5)
			call randomRange
			inc eax			; Add 1 for range (1-5)
			mov Table2[ebx+esi], eax
			add esi,TYPE Table2
		Loop N4

		mov eax,0
		mov count1,0
		mov count2,0

		pop ecx
		pop esi

		call checkRow2

		JMP Next

RowsCrushed:
	popa

ret 
checkRow2 endp
;/////////////////////////////////////////////////////

;////////////// column crushing-level-2 /////////////////////
checkColumn2 PROC

pusha

	mov count1,0
	mov count2,0

	mov ecx,10
	mov ebx,0
	mov esi,0

	colTraverse:
		push ecx
		mov ecx,9
		mov ebx,0

		rowTraverse:
			;Comparing two consecutive indexes

			mov eax,0
			cmp eax,Table2[ebx+esi]
			JE Next

			mov eax,Table2[ebx+esi]
			add ebx,rowsize
			cmp eax,Table2[ebx+esi]

			JE N1

			;Checking if 3 of them were similar
			mov eax,2
			cmp eax,count1
			JBE N3

			;If they are not similar set counts to 0
			mov eax,0
			mov count1,0
			mov count2,0

		Next:
		loop rowTraverse

		pop ecx
		add esi,type Table2
		mov eax,0
		mov count1,0
		mov count2,0
	loop colTraverse

	JMP colCrushed

	;counting number of elements to crush
	N1:
		inc count1
		mov eax,count1
		cmp eax,1

		JE N2
		JMP Next

	;Storing index from where to start crushing
	N2:
		mov count2,ebx
		sub count2,rowsize
		JMP Next

	;Crushing numbers
	N3:
		push ebx

		inc count1

		push ecx
		add score,3
		mov ecx,count1
		mov ebx,count2

		N4:
			Mov eax,5		; Random Number Range (0-5)
			call randomRange
			inc eax			; Add 1 for range (1-5)
			mov Table2[ebx+esi], eax
			add ebx,rowsize
		Loop N4

		mov eax,0
		mov count1,0
		mov count2,0

		pop ecx
		pop ebx

		call checkColumn2

		JMP Next

colCrushed:
	popa
	ret 
checkColumn2 endp

Blast PROC

call checkRow
call checkColumn

ret
Blast endp


END main