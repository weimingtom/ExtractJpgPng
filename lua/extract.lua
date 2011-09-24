require"imlua"
require"imlua_process"

function decompose(inputName, jpgName, pngName)
	local image = assert(im.FileImageLoad(inputName))
	local image2 = assert(im.ImageCreate(image:Width(), image:Height(), im.RGB, im.BYTE))
	local image3 = assert(im.ImageCreate(image:Width(), image:Height(), im.RGB + im.ALPHA , im.BYTE))

	local r1 = image[0]
	local g1 = image[1]
	local b1 = image[2]
	local a1 = image[3]

	local r2 = image2[0]
	local g2 = image2[1]
	local b2 = image2[2]

	local r3 = image3[0]
	local g3 = image3[1]
	local b3 = image3[2]
	local a3 = image3[3]

	for row = 0, image:Height() - 1 do
		for column = 0, image:Width() - 1 do
			r2[row][column] = r1[row][column]
			g2[row][column] = g1[row][column]
			b2[row][column] = b1[row][column]
			a3[row][column] = a1[row][column]
		end
	end

	image2:Save(jpgName, "JPEG")
	image3:Save(pngName, "PNG")
end

function compose(jpgName, pngName, outputName)
	local image1 = assert(im.FileImageLoad(jpgName))
	local image2 = assert(im.FileImageLoad(pngName))
	local image3 = assert(im.ImageCreate(image1:Width(), image1:Height(), im.RGB + im.ALPHA, im.BYTE))

	local r1 = image1[0]
	local g1 = image1[1]
	local b1 = image1[2]

	local r2 = image2[0]
	local g2 = image2[1]
	local b2 = image2[2]
	local a2 = image2[3]

	local r3 = image3[0]
	local g3 = image3[1]
	local b3 = image3[2]
	local a3 = image3[3]

	for row = 0, image1:Height() - 1 do
		for column = 0, image1:Width() - 1 do
			r3[row][column] = r1[row][column]
			g3[row][column] = g1[row][column]
			b3[row][column] = b1[row][column]
			a3[row][column] = a2[row][column]
		end
	end

	image3:Save(outputName, "PNG")
end

decompose('preview.png', 'output.jpg', 'output.png')
compose('output.jpg', 'output.png', 'new.png')
