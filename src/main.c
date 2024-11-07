

int AgbMain( void  )
{
	//set GBA rendering context to MODE 3 Bitmap Rendering
	*(unsigned int*)0x04000000 = 0x0403;
	unsigned short tile[32*32];
	int t = 0;
	while(1){
		int x,y;
		//create a 32x32 tile of coloured pixels
		for( y = 0; y < 32; ++y){
			for(x = 0; x < 32; ++x){
				int val = ((x&y)+t) & 0x1F;
									//r			//g		   //b
				tile[x+y*32] = ((val << 10)| (val<<5) | (val<<0));
			}
		}
		++t;
		
		//draw the screen by rendering the 32x32 tile 16 times
		int offset = 56 + (24*160);
		for( y = 0; y < 128; ++y ){
			for( x = 0; x < 128; ++x){
				int index = (x%32 + (y%32 * 32));
				int screen_pos = (x + ( y * 240));
				((unsigned short*)0x06000000)[offset + screen_pos] = tile[index];
			}
		}
	}
	return 0;
}