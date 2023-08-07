# Ordenando-Vetores-em-Assembly

Implementação de um projeto de ordenação de vetores em Assembly usando o algoritmo Bubble Sort. Esse código fonte foi desenvolvido como parte do estudo realizado na disciplina de Interface/Hardware Software.

## Compilação

Para compilar o projeto, execute o seguinte comando no terminal:

```
gcc -g -Wall main.s -o main.bin
```

## Execução

Para executar o projeto, utilize o seguinte comando no terminal:

```
./main.bin vetores.input vetores.output
```

O arquivo "vetores.input" deve conter na primeira linha o número de vetores a serem ordenados. Em seguida, para cada entrada, insira o tamanho do vetor na linha seguinte, seguido dos elementos do vetor separados por espaços.

Exemplo do conteúdo do arquivo "vetores.input":

```
3
5
3 1 4 2 5
7
9 6 2 8 4 1 7
2
6 3
```

O projeto irá ler os vetores a serem ordenados a partir do arquivo "vetores.input" e gerar o resultado ordenado no arquivo "vetores.output".

**Nota:** Certifique-se de ter o GCC (GNU Compiler Collection) instalado em seu sistema para compilar o projeto corretamente.
