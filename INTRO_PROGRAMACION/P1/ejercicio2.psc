Algoritmo ejercicio2
	Escribir "Introducir primera calificaci�n"
	Leer nota1
	Escribir "Introducir segunda calificaci�n"
	Leer nota2
	Escribir "Introducir tercera calificaci�n"
	Leer nota3
	Si nota1>nota2 Y nota2>nota3 Entonces
		calificaci�n_global <- (nota1+nota2)/2
	SiNo
		Si nota1<nota2 Y nota2<nota3 Entonces
			calificaci�n_global <- (nota2+nota3)/2
		SiNo
			Si nota1>nota2 Y nota2<nota3 Entonces
				calificaci�n_global <- (nota1+nota3)/2
			SiNo
				Si nota1<nota2 Y nota2>nota3 Entonces
				calificaci�n_global <- (nota1+nota2)/2
				FinSi
			FinSi
		FinSi
	Fin Si
	Escribir calificaci�n_global
FinAlgoritmo
