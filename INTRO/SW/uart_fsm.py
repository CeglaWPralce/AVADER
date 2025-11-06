file = open("data.txt", "r")
read_data = file.read()

data_ascii = [ord(c) for c in read_data]
result = ''

for c in read_data:
    b_repr = format(ord(c), '08b')
    result += b_repr

print(result.strip())
file.close()

with open("data_bin.txt", "w") as f:
  f.write(result)