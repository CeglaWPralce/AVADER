data_file = open("quantized_data.txt", "r")
wages_file = open("quantized_wages.txt", "r")
data_list = []
wage_list = []
for i in range(64):
    read_value = int(data_file.readline().strip())
    data_list.append(read_value)

for i in range(128):
    line = wages_file.readline().strip().split()
    wage_line = [int(x) for x in line]
    wage_list.append(wage_line)

data_file.close()
wages_file.close()

# Poprawiona pętla mnożenia macierzy
result = []
for i in range(128):  # iteracja po wyjściach (wierszach wag)
    sum_product = 0
    for j in range(64):  # iteracja po wejściach
        sum_product += data_list[j] * wage_list[i][j]  # poprawione indeksowanie
    result.append(sum_product)

output_file = open("matrix_mlp_result.txt", "w")
for value in result:
    output_file.write(f"{value}\n")

output_file.close()




