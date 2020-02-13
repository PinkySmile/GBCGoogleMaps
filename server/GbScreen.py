from abc import abstractmethod
from typing import List, Union, Tuple

def get_item_value(item, max_x=8):
        if isinstance(item, tuple):
            return item[1] * max_x + item[0]
        elif isinstance(item, int):
            return item
        else:
            raise TypeError(f"Given items key {item.__repr__} must be int or tuple, not a {type(item).__name__}")

class Tile:
    def __init__(self, default_value=0, max_x=8, max_y=8):
        self.pixels : List[int] = [default_value] * (max_x * max_y)

    def __getitem__(self, item: Union[int, Tuple[int, int]]) -> int:
        return self.pixels[get_item_value(item)]

    def __setitem__(self, key: Union[int, Tuple[int, int]], value: int):
        self.pixels[get_item_value(key)] = value

    def __eq__(self, other):
        return self.pixels == other.pixels


class GbScreen:
    def __init__(self, default_value=0):
        self.tiles = [Tile(default_value=default_value) for _ in range(1024)]  # type: List[Tile]
        self.camera_pos = (0, 0)  # type: Tuple[int, int]

    def get_tile(self, x, y=0) -> Tile:
        return self.tiles[y * 32 + x]

    def __getitem__(self, key: Tuple[int, int]) -> int:
        if not isinstance(key, tuple):
            raise TypeError("Item key for GbScreen's operator [] must be a tuple")
        x, y = key
        return self.get_tile(x // 8, y // 8)[x % 8, y % 8]

    def __setitem__(self, key: Tuple[int, int], value: int):
        if not isinstance(key, tuple):
            raise TypeError("Item key for GbScreen's operator [] must be a tuple")
        x, y = key
        self.get_tile(x // 8, y // 8)[x % 8, y % 8] = value

    def enumerate_coords(self):
        for j in range(0x100):
            for i in range(0x100):
                yield i, j
        return

    def enumerate_pixel(self):
        for i, j in self.enumerate_coords():
                yield i, j, self[i, j]
        return
