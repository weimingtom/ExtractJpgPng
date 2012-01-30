require"imlua"
require"imlua_process"

function decomposejpg(inputName, jpgName, horizontal)
	local image = assert(im.FileImageLoad(inputName))
	local image2
	if horizontal then
		image2 = assert(im.ImageCreate(image:Width() * 2, image:Height(), im.RGB, im.BYTE))
	else
		image2 = assert(im.ImageCreate(image:Width(), image:Height() * 2, im.RGB, im.BYTE))
	end

	local r1 = image[0]
	local g1 = image[1]
	local b1 = image[2]
	local a1 = image[3]

	local r2 = image2[0]
	local g2 = image2[1]
	local b2 = image2[2]

	local w = image:Width()
	local h = image:Height()
	if horizontal then
		for row = 0, image:Height() - 1 do
			for column = 0, image:Width() - 1 do
				r2[row][column] = r1[row][column]
				g2[row][column] = g1[row][column]
				b2[row][column] = b1[row][column]
				r2[row][column + w] = a1[row][column]
				g2[row][column + w] = a1[row][column]
				b2[row][column + w] = a1[row][column]
			end
		end
	else
		for row = 0, image:Height() - 1 do
			for column = 0, image:Width() - 1 do
				r2[row + h][column] = r1[row][column]
				g2[row + h][column] = g1[row][column]
				b2[row + h][column] = b1[row][column]
				r2[row][column] = a1[row][column]
				g2[row][column] = a1[row][column]
				b2[row][column] = a1[row][column]
			end
		end
	end

	image2:Save(jpgName, "JPEG")
end

function composejpg(jpgName, outputName, horizontal)
	local image1 = assert(im.FileImageLoad(jpgName))
	local image2
	if horizontal then
		image2 = assert(im.ImageCreate(image1:Width() / 2, image1:Height(), im.RGB + im.ALPHA, im.BYTE))
	else
		image2 = assert(im.ImageCreate(image1:Width(), image1:Height() / 2, im.RGB + im.ALPHA, im.BYTE))
	end

	local r1 = image1[0]
	local g1 = image1[1]
	local b1 = image1[2]

	local r2 = image2[0]
	local g2 = image2[1]
	local b2 = image2[2]
	local a2 = image2[3]

	if horizontal then
		local w = image1:Width() / 2
		local h = image1:Height()
		for row = 0, h - 1 do
			for column = 0, w - 1 do
				r2[row][column] = r1[row][column]
				g2[row][column] = g1[row][column]
				b2[row][column] = b1[row][column]
				a2[row][column] = r1[row][column + w]
			end
		end
	else
		local w = image1:Width()
		local h = image1:Height() / 2
		for row = 0, h - 1 do
			for column = 0, w - 1 do
				r2[row][column] = r1[row + h][column]
				g2[row][column] = g1[row + h][column]
				b2[row][column] = b1[row + h][column]
				a2[row][column] = r1[row][column]
			end
		end
	end

	image2:Save(outputName, "PNG")
end

local horizontal = false
decomposejpg('preview.png', 'output.jpg', horizontal)
composejpg('output.jpg', 'output.png', horizontal)
