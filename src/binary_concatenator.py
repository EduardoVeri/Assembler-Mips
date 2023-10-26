
import sys
import os
import struct

green_text = "\033[92m"
red_text = "\033[91m"
end_text = "\033[0m"

# Choose the order of the files to be concatenated in the final file
file_order = {
    "soma_funcao": 0,
    "calculo_media": 1,
    "fibonacci": 2,
    "fatorial_iterativo": 3,
    "fatorial_recursivo": 4,
    "modulo": 5,
    "num_primo": 6,
    "potencia": 7,
    "mdc": 8,
    "sort": 9
}

def main():
    try:
        # Get every file in the input folder
        files = os.listdir("project/input")

        final_file = open("bin/final_file.txt", "w")

        with open("bin/bin.txt", "r") as so_file:
            count = 0
            for line in so_file:
                final_file.write(line)
                count += 1
            final_file.write("00000011111111111111100000100000\n"*(150-count))

        # Sort the files in "files" list by the order in file_order dict
        files.sort(key=lambda x: file_order[x.split(".")[0]])

        for arq in files:
            print("Concatenando arquivo:", arq, '...')
            with open("project/input/" + arq, "r") as open_file:
                content = open_file.read()

            count = 0
            for line in content.split("\n"):
                if line != "":
                    count += 1
                    final_file.write(line + "\n")

            if count < 250:
                final_file.write("00000011111111111111100000100000\n"*(150-count))

        final_file.close()
        print(green_text, "Concatenação Finalizada com sucesso!", end_text, sep="")

    except Exception as e:
        print(red_text, "Erro ao concatenar arquivos:", e, end_text, sep="")

if __name__ == "__main__":
    main()