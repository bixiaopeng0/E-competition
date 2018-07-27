module vga(
			input 	clk,
			input 	rst_n,
			
			output reg VGA_HS,		//列同步信号
			output reg VGA_VS,		//行同步信号
			output 	en,
			output	[10:0]	en1,
			output	[10:0]	en2,
			output	VGA_CLK
		);

 parameter hy_all = 11'd1904,		//列时序
			 hy_a = 11'd152,			
			 hy_b = 11'd232,
			 hy_c = 11'd1440,
			 hy_d = 11'd80,
			 
			 vy_all = 11'd932,			//行时序
			 vy_a = 11'd3,
			 vy_b = 11'd28,
			 vy_c = 11'd900,
			 vy_d = 11'd1;
	
		//用计数器限定VGA显示的相应区域
	reg [10:0] cnt_h;			//列计数器
	reg [10:0] cnt_v;			//行计数器

//*************列计数*****************
 always @(posedge clk or negedge rst_n)
	if(!rst_n)
		cnt_h <= 11'd0;
	else if (cnt_h == (hy_all - 1))
		cnt_h <= 11'd0;
	else
		cnt_h <= cnt_h + 1'b1;

//**************行计数**************
 always @(posedge clk or negedge rst_n)
	if (!rst_n)
		cnt_v <= 11'd0;
	else if (cnt_v == (vy_all-1))
		cnt_v <= 11'd0;
	else if (cnt_h == (hy_all - 1))
		cnt_v <= cnt_v + 1'b1;

//********限定列同步信号************
 always @(posedge clk or negedge rst_n)
	if (!rst_n)
	VGA_HS <= 1'b1;		//复位时列同步信号高电平】
	else if (cnt_h == 'd0)
		VGA_HS <= 1'b0;
	else if (cnt_h == hy_a)
		VGA_HS <= 1'b1;
		
//***********限定列同步信号*
 always @(posedge clk or negedge rst_n)
	if (!rst_n)
	VGA_VS <= 1'b1;		//复位时列同步信号高电平】
	else if (cnt_v == 'd0)
		VGA_VS <= 1'b0;
	else if (cnt_v == vy_a)
		VGA_VS <= 1'b1;  

	//******限定显示有效区域，设使能信号
// wire [10:0] en1;		//列有效标志,x地址哦
// wire [10:0] en2;		//行，y地址
		
 assign en1 = (cnt_h >= hy_a + hy_b && cnt_h <= hy_a + hy_b + hy_c)?(cnt_h - hy_a - hy_b):11'd0;
 assign en2 = (cnt_v >= vy_a + vy_b && cnt_v <= vy_a + vy_b + vy_c)?(cnt_v - vy_a - vy_b):11'd0;
 assign en = (en1 > 0 && en2 >0 ) ? 1'b1 : 1'b0;
 assign	VGA_CLK = clk;
endmodule