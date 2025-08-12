Algoritmo ejercicio2
	Escribir "Introducir primera calificación"
	Leer nota1
	Escribir "Introducir segunda calificación"
	Leer nota2
	Escribir "Introducir tercera calificación"
	Leer nota3
	Si nota1>nota2 Y nota2>nota3 Entonces
		calificación_global <- (nota1+nota2)/2
	SiNo
		Si nota1<nota2 Y nota2<nota3 Entonces
			calificación_global <- (nota2+nota3)/2
		SiNo
			Si nota1>nota2 Y nota2<nota3 Entonces
				calificación_global <- (nota1+nota3)/2
			SiNo
				Si nota1<nota2 Y nota2>nota3 Entonces
				calificación_global <- (nota1+nota2)/2
				FinSi
			FinSi
		FinSi
	Fin Si
	Escribir calificación_global
FinAlgoritmo
