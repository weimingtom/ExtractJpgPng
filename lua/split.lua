require"imlua"
require"imlua_process"

local inputname = arg[1] or 'split.jpg'
ROW_MAX = arg[2] or 2
COLUMN_MAX = arg[3] or 3
OUTPUT_DIR = arg[4] or '.\\'

local image = im.FileImageLoad(inputname)

for row_index = 0, ROW_MAX - 1 do
	for column_index = 0, COLUMN_MAX - 1 do
		local image2 = im.ImageCreate(image:Width() / COLUMN_MAX, image:Height() / ROW_MAX, im.RGB, im.BYTE)
		local r = image2[0]
		local g = image2[1]
		local b = image2[2]

		local r1 = image[0]
		local g1 = image[1]
		local b1 = image[2]

		for row = 0, image:Height() / ROW_MAX - 1 do
			for column = 0, image:Width() / COLUMN_MAX - 1 do
				r[row][column] = r1[row + row_index * image:Height() / ROW_MAX ][column + column_index * image:Width() / COLUMN_MAX]
				g[row][column] = g1[row + row_index * image:Height() / ROW_MAX ][column + column_index * image:Width() / COLUMN_MAX]
				b[row][column] = b1[row + row_index * image:Height() / ROW_MAX ][column + column_index * image:Width() / COLUMN_MAX]
			end
		end

		image2:Save(OUTPUT_DIR ..'output_'..(ROW_MAX - 1 - row_index)..'_'..column_index..'.jpg', "JPEG")
	end
end

