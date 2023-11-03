'''
    This is a script for taking the .pngs exported by my R notebooks and giving them
    an alpha channel (and a transparent background).  Currently, there is no support
    for pixel-by-pixel manipulation by R (why should there be, really?), so I'm
    doing it in Python.
'''

# imports:
import os
from PIL import Image
from tqdm import tqdm # progress bar library

# Change to export directory with all of the images in it
os.chdir("../exports/")

# Loop through images, loop through pixels, add appropriate alpha
for file_name in tqdm(os.listdir(os.getcwd())):
    if file_name.endswith(".png") and not file_name.endswith("alpha.png"):
        img = Image.open(file_name)
        img.load() # make pixels accessible
        img.putalpha(alpha=255) # 255 => fully opaque
        width, height = img.size
        for col in range(width):
            for row in range(height):
                # If it is black on this pixel, make it transparent:
                if img.getpixel((col, row))[0] == 0:
                    img.putpixel((col, row), (255, 0))
        new_file_name = file_name[:-4] + "_alpha" + ".png"
        img.save(new_file_name)