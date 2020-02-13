import pygame

from ArgParser import arg_parser
from GbScreen import GbScreen
from GoogleMaps import get_maps_png
from ImageManip import get_image

args = arg_parser.parse_args()
pygame.init()

GB_COLOR = [(0x00, 0x00, 0x00), (0x55, 0x55, 0x55), (0xAA, 0xAA, 0xAA), (0xFF, 0xFF, 0xFF)]

def main():
    gbs = GbScreen()
    window_surface = pygame.display.set_mode((256, 256), flags=pygame.RESIZABLE)
    clock = pygame.time.Clock()
    surface = pygame.Surface((256, 256))
    data = get_image()
    pix_array = [(3 if i else 0) for i in data]
    for i, v in enumerate(pix_array):
        gbs[i % 256, i // 256] = v

    while True:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                return
            if event.type == pygame.VIDEORESIZE:
                window_surface = pygame.display.set_mode((event.w, event.h),pygame.RESIZABLE)
        for i, j, c in gbs.enumerate_pixel():
            surface.fill(GB_COLOR[c], ((i, j), (1, 1)))

        pygame.transform.scale(surface, window_surface.get_size(), window_surface)
        pygame.display.flip()


main()
