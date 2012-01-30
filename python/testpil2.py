#!c:/python26/python.exe
#
# need PIL
# see
# http://www.pythonware.com/products/pil/
# http://www.pythonware.com/library/pil/handbook/introduction.htm
# http://www.pythonware.com/library/pil/handbook/image.htm
# http://www.riaidea.com/blog/archives/279.html
#
from PIL import Image

def decomposejpg(inputName, jpgName, horizontal):
	im = Image.open(inputName)
	im.load()
	if horizontal:
		outim = Image.new("RGB", (im.size[0] * 2, im.size[1]))
	else:
		outim = Image.new("RGB", (im.size[0], im.size[1] * 2))
	outim.paste(im, (0, 0))
	source = im.split()
	source[0].paste(source[0].point(lambda i: 0xff), None)
	im = Image.merge(im.mode, (source[3], source[3], source[3], source[0]))
	if horizontal:
		outim.paste(im, (im.size[0], 0))
	else:
		outim.paste(im, (0, im.size[1]))
	outim.save(jpgName)

def composejpg(jpgName, pngName, horizontal):
	jpgIm = Image.open(jpgName)
	jpgIm.load()
	if horizontal:
		outim = Image.new("RGBA", (jpgIm.size[0] / 2, jpgIm.size[1]))
		img1 = jpgIm.crop((0, 0, jpgIm.size[0] / 2, jpgIm.size[1])).split()
		img2 = jpgIm.crop((jpgIm.size[0] / 2, 0, jpgIm.size[0], jpgIm.size[1])).split()
	else:
		outim = Image.new("RGBA", (jpgIm.size[0], jpgIm.size[1] / 2))
		img1 = jpgIm.crop((0, 0, jpgIm.size[0], jpgIm.size[1] / 2)).split()
		img2 = jpgIm.crop((0, jpgIm.size[1] / 2, jpgIm.size[0], jpgIm.size[1])).split()
	im = Image.merge("RGBA", (img1[0], img1[1], img1[2], img2[0]))
	im.save(pngName)
	
horizontal = 1
decomposejpg("preview.png", "out.jpg", horizontal)
composejpg("out.jpg", "out.png", horizontal)
