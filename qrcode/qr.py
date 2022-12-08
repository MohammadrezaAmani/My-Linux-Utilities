# pip install qrcode
import qrcode
import random
import os

# getting text inputs,
#   if you want to stop, type "end0"
text = ""
print("type text: ", end=" ")
inp = input()
while inp != "end0":
    text += inp
    inp = input()
    text += "\n"

# generating qr code
qr = qrcode.QRCode(
    version=1,
    error_correction=qrcode.constants.ERROR_CORRECT_L,
    box_size=10,
    border=4,
)
qr.add_data(text)
qr.make(fit=True)
img = qr.make_image(fill_color="black", back_color="white")
id = str(random.randint(1, 5000)) + ".png"
img.save(os.path.dirname(__file__) + "/" + id)

# showing qr code image
os.system("xdg-open %s" % (os.path.dirname(__file__) + "/" + id))
os.remove(os.path.dirname(__file__) + "/" + id)
