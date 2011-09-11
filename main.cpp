#pragma warning(disable:4996)

/*
http://stackoverflow.com/questions/2442335/libpng-boostgil-png-infopp-null-not-found

libpng 1.4 dropped definitions of png_infopp_NULL and int_p_NULL. So add
#define png_infopp_NULL (png_infopp)NULL
#define int_p_NULL (int*)NULL
in your code before including GIL headers.
*/
#define png_infopp_NULL (png_infopp)NULL
#define int_p_NULL (int*)NULL

#include <boost/gil/image.hpp>
#include <boost/gil/typedefs.hpp>
#include <boost/gil/extension/io/png_io.hpp>
#include <boost/gil/extension/io/jpeg_io.hpp>
#include <boost/gil/extension/numeric/sampler.hpp>
#include <boost/gil/extension/numeric/resample.hpp>

void copy3channel(const boost::gil::rgba8c_view_t& src, const boost::gil::rgb8_view_t& dst) 
{
	using namespace boost::gil;

	for (int y = 0; y < src.height(); ++y) 
	{
		rgba8c_view_t::x_iterator src_it = src.row_begin(y);
		rgb8_view_t::x_iterator dst_it = dst.row_begin(y);
	
		for (int x = 1; x < src.width(); ++x)
		{
			dst_it[x][0] = src_it[x][0];
			dst_it[x][1] = src_it[x][1];
			dst_it[x][2] = src_it[x][2];
		}
	}
}

void copyalphachannel(const boost::gil::rgba8c_view_t& src, const boost::gil::rgba8_view_t& dst) 
{
	using namespace boost::gil;

	for (int y = 0; y < src.height(); ++y) 
	{
		rgba8c_view_t::x_iterator src_it = src.row_begin(y);
		rgba8_view_t::x_iterator dst_it = dst.row_begin(y);
	
		for (int x = 1; x < src.width(); ++x)
		{
			dst_it[x][0] = 0;
			dst_it[x][1] = 0;
			dst_it[x][2] = 0;
			dst_it[x][3] = src_it[x][3];
		}
	}
}

void composechannel(const boost::gil::rgb8c_view_t& src1, 
					const boost::gil::rgba8c_view_t& src2,
					const boost::gil::rgba8_view_t& dst)
{
	using namespace boost::gil;

	if(src1.height() != src2.height() || src1.width() != src2.width())
		return ;

	for (int y = 0; y < src1.height(); ++y) 
	{
		rgb8c_view_t::x_iterator src1_it = src1.row_begin(y);
		rgba8c_view_t::x_iterator src2_it = src2.row_begin(y);
		rgba8_view_t::x_iterator dst_it = dst.row_begin(y);
	
		for (int x = 1; x < src1.width(); ++x)
		{
			dst_it[x][0] = src1_it[x][0];
			dst_it[x][1] = src1_it[x][1];
			dst_it[x][2] = src1_it[x][2];
			dst_it[x][3] = src2_it[x][3];
		}
	}
}

int main(int argc, const char *argv[]) 
{
	if(argc < 5)
	{
		printf("usage: \n"
			   "	myaffine decompose input.jpg output.jpg output.png\n"
			   "	myaffine compose input.jpg input.png output.png\n");
		return 0;
	}

	using namespace boost::gil;

	if(!stricmp(argv[1], "decompose"))
	{    
		// decompose input.png out.jpg out2.png
		try 
		{
			rgba8_image_t img;
			png_read_image(argv[2], img);
			rgb8_image_t img_out(img.dimensions());
			rgba8_image_t aimg_out(img.dimensions());

			copy3channel(const_view(img), view(img_out));
			copyalphachannel(const_view(img), view(aimg_out));
			
			jpeg_write_view(argv[3], view(img_out), 80);
			png_write_view(argv[4], view(aimg_out));
		} 
		catch(...)
		{
			printf("affine error!\n");
		}
	}
	else if(!stricmp(argv[1], "compose"))
	{
		// compose caa00.jpg caa00.png caa_output.png
		try
		{
			rgb8_image_t img;
			rgba8_image_t aimg;
			jpeg_read_image(argv[2], img);
			png_read_image(argv[3], aimg);
			rgba8_image_t aimg_out(img.dimensions());
			
			composechannel(const_view(img), const_view(aimg), view(aimg_out));
			
			png_write_view(argv[4], view(aimg_out));
		} 
		catch(...)
		{
			printf("affine error!\n");
		}
	}
	else
	{
		printf("affine error!\n");
	}

    return 0;
}

