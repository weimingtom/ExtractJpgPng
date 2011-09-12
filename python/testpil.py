#!c:/python26/python.exe
#
# need PIL
# see
# http://www.pythonware.com/products/pil/
# http://www.pythonware.com/library/pil/handbook/introduction.htm
#
# PIL split() bug fix:
# if im.mode == 'RGBA' and Image.VERSION.startswith('1.1.7'):
#   im.load()
# AttributeError: 'NoneType' object has no attribute 'bands'
# see
# http://code.google.com/p/xhtml2pdf/issues/detail?id=65
from PIL import Image

# def cal(x):
#    return 0xcc

def decompose(inputName, jpgName, pngName):
    # lazy operation
    im = Image.open(inputName)
    # FIXME: not sure
    # if im.mode == 'RGBA' and Image.VERSION.startswith('1.1.7'):
    im.load()
    im.save(jpgName)
    source = im.split()
    # r, g, b
    for index in range(3):
        # print(index)
        source[index].paste(source[index].point(lambda i: 0), None)
    im = Image.merge(im.mode, source)
    im.save(pngName)

def compose(jpgName, pngName, outputName):
    jpgIm = Image.open(jpgName)
    pngIm = Image.open(pngName)
    im = Image.composite(jpgIm, pngIm, pngIm)
    im.save(outputName)

decompose("preview.png", "out.jpg", "out.png")
compose("out.jpg", "out.png", "new.png")
