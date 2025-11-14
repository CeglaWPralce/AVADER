data_mlp_file = open("matrix_mlp_result.txt", "r")
quantized_output = []
for i in range(128):
    read_value = int(data_mlp_file.readline().strip())
    quantized_output.append(read_value)

data_file = open("data.txt", "r")
data_list = []

for i in range(64):
    read_value = float(data_file.readline().strip())
    data_list.append(read_value)

data_file.close()

x_max = max(data_list)
x_min = min(data_list)
data_scale = (x_max - x_min) / 255.0
data_zero_point = round(-x_min / data_scale)
data_zero_point = max(0, min(255, data_zero_point))


# Read wages
with open("wages.txt", "r") as data_file:
    wage_list = []
    for line in data_file:  # reads all lines
        numbers = [float(x) for x in line.strip().split()]
        wage_list.append(numbers)

# Quantization parameters
x_max = max(v for line in wage_list for v in line)
x_min = min(v for line in wage_list for v in line)
wages_scale = (x_max - x_min) / 255.0
wages_zero_point = round(-x_min / wages_scale)
wages_zero_point = max(0, min(255, wages_zero_point))

sum_wages = sum(sum(line) for line in wage_list)
sum_data = sum(data_list)
N = len(wage_list[0])
for i in range(128):
    output_scale = data_scale * wages_scale * N
    dequantized_output = [output_scale * q for q in quantized_output]

output_file = open("dequantized_result.txt", "w")
for value in dequantized_output:
    output_file.write(f"{value}\n")





