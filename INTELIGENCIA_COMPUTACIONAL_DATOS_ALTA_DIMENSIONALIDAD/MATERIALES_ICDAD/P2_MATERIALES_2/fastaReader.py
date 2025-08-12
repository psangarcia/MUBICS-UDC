#coding=utf8
from pyspark import SparkContext, SparkConf

# Función auxiliar - No es necesario modificarla
def findLastSmallerEqual(query, elements):
        '''
        Dada una lista ordenada elements, devuelve el mayor de sus elementos que
        aún sea menor que query
        '''
        previous=-1
        for e in elements:
                # Si encontramos uno mayor, devolvemos el anterior
                if e>query:
                        return previous
                previous=e
        # Si no hemos encontrado ninguno mayor, devolvemos el último
        return previous

# Función auxiliar - No es necesario modificarla
def listToSequenceTuple(groupElements):
        '''
        Dada una lista de tuplas (cadena, número_línea) groupElements devuelve
        una tupla (cabecera, secuencia) donde ambas son cadenas. La cabecera se
        corresponderá con el elemento de groupElements que empiece por '>' (del
        que habrá uno y solo uno) y secuencia consiste en concatenar el resto de
        cadenas habiéndolas ordenado por su número_línea.
        '''
        header=None # Aquí guardaremos la cabecera
        seqParts=[] # Aquí guardaremos los elementos que no son cabecera
        for seqPart,lineNumber in groupElements: # Recorremos para separar cabeceras
                if seqPart[0]=='>':
                        header=seqPart
                else:
                        seqParts.append((lineNumber,seqPart))
        # Ordenamos los elementos que no son cabeceras atendiendo a su número de línea
        seqParts.sort(key=lambda lineNumber_seqPart: lineNumber_seqPart[0])
        # Juntamos las secuencias ya ordenadas
        sequence="".join(map(lambda lineNumber_seqPart: lineNumber_seqPart[1], seqParts))
        return (header,sequence)

# Cuerpo del programa
if __name__ == "__main__":
        conf = SparkConf().setAppName("FastaReader").setMaster("local[8]")
        sc=SparkContext.getOrCreate(conf=conf)

        #seqsRDD es un RDD de tuplas (línea, número de línea)
        seqsRDD=sc.textFile('/media/sf_PR_ICDAD/Materiales_parte2/schizophrenia.fasta').zipWithIndex()

        # TODO - Manipula seqsRDD para obtener numerosCabeceras, que será una
        # lista de números que solo contiene los números de línea que
        # corresponden a cabeceras.

        def filtro(s):
                if s[0].startswith(">"): return True
                return False

        filtrado=seqsRDD.filter(filtro)

        numerosCabeceras=filtrado.map(lambda c: c[1]).collect()

        # Ordenamos la lista de cabeceras para tenerlas por orden creciente.
        numerosCabeceras.sort()

        # TODO - Manipula seqsRDD para obtener groupedRDD, que será un RDD de
        # tuplas (núm línea de cabecera, lista de líneas asociadas a esa cabecera)
        # (ver ejemplo)

        groupedRDD=seqsRDD.map(lambda c: (findLastSmallerEqual(c[1],numerosCabeceras),c))

        # TODO - Manipula groupedRDD para obtener secuencesRDD, que será un RDD
        # de tuplas (cabecera, secuencia)

        grouped_por_cabeceras = groupedRDD.groupByKey().map(lambda x: (x[0], list(x[1])))

        sequencesRDD = grouped_por_cabeceras.map(lambda x: listToSequenceTuple(x[1]))

        print(sequencesRDD.first())
        print(sequencesRDD.count())

        # TODO - Guarda sequencesRDD como fichero de texto en HDFS. Tendrás que
        # indicarle una ruta de la forma hdfs://<servidor>:<puerto><ruta_absoluta_HDFS>

        sequencesRDD.saveAsTextFile("hdfs://localhost:9000/p5/sequencesRDD.txt")

        sc.stop()
        exit()