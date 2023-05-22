#########################################################
#        All numbers are in hex format   				#
#        We always start by reset signal 				#
#########################################################
#         This is a commented line
#        You should ignore empty lines and commented ones
# ---------- Don't forget to Reset before you start anything ---------- #


.org 0	#this means the the following line would be  at address  0 , and this is the reset address
100							
.org 1	#this hw interrupt handler
20						

#test case 1
.ORG 100  					#this is int 1
INC R0, R0					# r0 <- 1, flags -> 0
INC R0, R0				    # R0 <- 2 , ALU-ALU FORWARDING, flags -> 0
LDM R2, 09					# r2 <- 9
DEC R0, R0					# r0 <- 1  M1-ALU FORWARD, flags -> 4
ADD R3, R2, R0				# R3 <- 0A,forward on both parameters,flags -> 0
IADD R4, R2, FF00				# R4 <- FF09  m2-alu forward, flags->2

# test case 2
IN R1						# R1<-44H, INPUT PORT 44h
MOV 	R4, R1					# R4 <- 44H, Alu-alu forward
OR      R5, R4, R2				# R5 <- 4D ,  flags → 0
OUT   	R4					# m1-alu forward	

#test case 3, load use test
Push R1
POP R7					#structural hazard
AND R1, R5, R7				#load use   R1<-4D & 44 = 44h
OR   R2, R1, R7				#load use and forward

#test case 4, structural hazard with data hazard
STD R0, R4					#store in memory					
LDD R6, R0					#structural hazard
STD R3, R6					#structural hazard and load use
SUB R5, R6, R3				# 🙂 forward m2-alu 🙂 after stall
NOP
NOP 
