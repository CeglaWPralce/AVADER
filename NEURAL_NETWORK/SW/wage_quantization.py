# Read wages
with open("wages.txt", "r") as data_file:
    wage_list = []
    for line in data_file:  # reads all lines
        numbers = [float(x) for x in line.strip().split()]
        wage_list.append(numbers)

# Quantization parameters
x_max = max(v for line in wage_list for v in line)
x_min = min(v for line in wage_list for v in line)
scale = (x_max - x_min) / 255.0
zero_point = round(-x_min / scale)
zero_point = max(0, min(255, zero_point))

# Write quantized wages
with open("quantized_wages.txt", "w") as data_file:
    for line in wage_list:  
        for value in line:  
            q_value = int(round(value / scale + zero_point))
            data_file.write(f"{q_value} ")
        data_file.write("\n")

print(zero_point)
print(scale)