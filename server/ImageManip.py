from PIL import Image
from GbScreen import GbScreen

def crop_to_square(im : Image.Image):
    width, height = im.size
    new_size = min(width, height)
    left = (width - new_size) / 2
    top = (height - new_size) / 2
    right = (width + new_size) / 2
    bottom = (height + new_size) / 2
    return im.crop((left, top, right, bottom))


def get_image():
    im = Image.open("exemple.png")  # type: Image.Image
    im = crop_to_square(im)
    im = im.resize((256, 256))
    im = im.convert('1')
    return im.getdata()

    # Crop the center of the image

    with open("dbg.png", 'wb') as fd:
        im.save(fd)