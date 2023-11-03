'''
    This is a script for taking the .pngs exported by my R notebooks and giving them
    an alpha channel (and a transparent background).  Currently, there is no support
    for pixel-by-pixel manipulation by R (why should there be, really?), so I'm
    doing it in Python.
'''
# options:
colors_reverse = False

# imports:
import os
from PIL import Image, ImageColor
from tqdm import tqdm # progress bar library
from colors import * # custom colors list from elsewhere (based of matplotlib magma)

# Change to export directory with all of the images in it
os.chdir("../exports/")

if colors_reverse:
    colors = colors.reverse()

# Loop through images, loop through pixels, add colors & alpha channel
file_index = 0
for file_name in tqdm(sorted(os.listdir(os.getcwd()))):
    if file_name.endswith(".png") and not file_name.endswith("alpha.png"):
        img = Image.open(file_name)
        rgba_img = Image.new("RGBA", img.size) # load new image w/ RGB and alpha channels
        img.load() # make pixels accessible
        rgba_img.load() # ''
        width, height = img.size
        for col in range(width):
            for row in range(height):
                # If it is black on this pixel, make it transparent:
                if img.getpixel((col, row)) == 0:
                    rgba_img.putpixel((col, row), (0,0,0,0))
                else:
                    rgba_img.putpixel((col, row), ImageColor.getcolor(colors[file_index], "RGBA"))
        new_file_name = file_name[:-4] + "_alpha" + ".png"
        rgba_img.save(new_file_name)
        file_index += 1