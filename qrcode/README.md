### QRCode

for sharing codes, texts, links, etc between devices i need to use telegram, whatsapp, etc. but i don't want to use them. so i made this.

#### Usage
open terminal using `ctrl+alt+t` and type `qrcode` and then type the text you want to share. it will generate a qr code and save it in your file directory. then you can share it using any app you want.

#### Installation

1. download the script from [here](/qrcode/qr.py)
2. ```python3
    pip install qrcode
    ```
3. run script using `python3 qr.py`
   
### adding to path

1. if you are using bash, add this to your `.bashrc` file
    ```bash
    alias qrcode="python3 /path/to/qr.py"
    ```
2. if you are using zsh, add this to your `.zshrc` file
    ```zsh
    alias qrcode="python3 /path/to/qr.py"
    ```
3. if you are using fish, add this to your `.config/fish/config.fish` file
    ```fish
    alias qrcode="python3 /path/to/qr.py"
    ```
4. if you are using any other shell, add this to your shell's config file
    ```shell
    alias qrcode="python3 /path/to/qr.py"
    ```
5. save the file and restart your terminal

have FUN! :')
