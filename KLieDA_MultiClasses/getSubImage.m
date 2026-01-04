function subimg = getSubImage(I, sy, sx, height, width)
subimg = I(sy:sy+height,sx:sx+width);