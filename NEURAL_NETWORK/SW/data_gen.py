import random

data_file = open("data.txt", "w")
for i in range(64):
    value = random.uniform(-1, 1)  
    data_file.write(f"{value}\n")




