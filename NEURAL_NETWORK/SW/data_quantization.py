data_file = open("data.txt", "r")
data_list = []

for i in range(64):
    read_value = float(data_file.readline().strip())
    data_list.append(read_value)

data_file.close()

x_max = max(data_list)
x_min = min(data_list)
scale = (x_max - x_min) / 255.0
zero_point = round(-x_min / scale)
zero_point = max(0, min(255, zero_point))

data_file = open("quantized_data.txt", "w")
for i in range(64):
    value = int(round(data_list[i] / scale + zero_point))
    data_file.write(f"{value}\n")

data_file.close()

print(zero_point)
print(scale)