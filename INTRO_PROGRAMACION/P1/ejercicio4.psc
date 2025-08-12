Algoritmo sin_titulo
	Escribir "Introducir un valor"
	Leer n
	Repetir
		Si nMOD2=0 Entonces 
			 n <- trunc(n/2)
		SiNo 
			n <- (n*3)+1
		FinSi
	Escribir n
	Hasta Que n=1
FinAlgoritmo
