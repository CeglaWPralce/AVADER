import random

data_file = open("wages.txt", "w")

for i in range(128):
    for i in range(64):
        value = random.uniform(-1, 1)
        data_file.write(f"{value}")
        data_file.write(" ")
    data_file.write("\n")
    
data_file.close()