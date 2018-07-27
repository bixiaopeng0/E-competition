module	T_0_T(
					clk,
					rst_n,
//					zx_P,			//正弦波频率
//					zx_F,			//正弦波幅值
//					fzx_P,		//非正弦波频率
//					fzx_F,		//非正弦波幅值
//					ram_data,
//					ram_addr,
//					fzx_2_F,		//二次谐波幅值
//					fzx_3_F,		//三次谐波幅值
//					fzx_4_F,		//四次谐波幅值
//					fzx_5_F,		//五次谐波幅值
					
					VGA_HS,
					VGA_VS,
					VGA_CLK,
					VGA_R,
					VGA_B,
					VGA_G
				);
				
			input 				clk;
			input				rst_n;
			
//			input	[15:0]		zx_P;			//正弦信号频率
//			input	[15:0]		zx_F;			//正弦信号幅值
//			input	[15:0]		fzx_P;		//非正弦信号频率
//			input	[15:0]		fzx_F;		//非正弦信号幅值
//			input	[9:0]			ram_data;
//			input	[9:0]			ram_addr;
//			input	[15:0]		fzx_2_F;		//非正弦信号2次谐波幅值
//			input	[15:0]		fzx_3_F;		//非正弦信号3次谐波幅值
//			input	[15:0]		fzx_4_F;		//非正弦信号4次谐波幅值
//			input	[15:0]		fzx_5_F;		//非正弦信号5次谐波幅值
				
			output	[7:0]		VGA_R;			
			output	[7:0]		VGA_G;		
			output	[7:0]		VGA_B;
			output				VGA_CLK;	
			output				VGA_HS;
			output				VGA_VS;
			
			wire	[15:0]		zx_P = 16'd387;	//正弦信号频率
			wire	[15:0]		zx_F = 16'd345;	//正弦信号幅值
			wire	[15:0]		fzx_P = 16'd100; //非正弦信号频率 ;
			wire	[15:0]		fzx_F  = 16'd480;//非正弦信号幅值 ;
			wire	[15:0]		fzx_2_F = 16'd0;		//非正弦信号2次谐波幅值
			wire [15:0]		fzx_3_F = 16'd40;		//非正弦信号3次谐波幅值
			wire [15:0]		fzx_4_F = 16'd0;		//非正弦信号4次谐波幅值
			wire  [15:0]		fzx_5_F = 16'd3;		//非正弦信号5次谐波幅值
			
			wire switch = 1'b1;
			T_0_top T_0_top_inst(
					.clk(clk),
					.rst_n(rst_n),
					.zx_P(zx_P),			//正弦波频率
					.zx_F(zx_F),			//正弦波幅值
					.fzx_P(fzx_P),		//非正弦波频率
					.fzx_F(fzx_F),		//非正弦波幅值
//					.ram_data(),
//					.ram_addr(),
					.fzx_2_F(fzx_2_F),		//二次谐波幅值
					.fzx_3_F(fzx_3_F),		//三次谐波幅值
					.fzx_4_F(fzx_4_F),		//四次谐波幅值
					.fzx_5_F(fzx_5_F),		//五次谐波幅值
					
					//.clk_106M(clk_106M),
					//.q_ram(q_ram),
					//.rd_ram(rd_ram),
					.switch(switch),
					.VGA_HS(VGA_HS),
					.VGA_VS(VGA_VS),
					.VGA_CLK(VGA_CLK),
					.VGA_R(VGA_R),
					.VGA_B(VGA_B),
					.VGA_G(VGA_G)
					);
				
		//wire	[9:0]	rd_ram;
		//wire	[9:0]	q_ram;
	//	wire clk_106M;
//——————————————————————————————————————
 //测试
 /*
ceshirom1 ceshirom1_inst (
	.address(rd_ram),
	.clock(clk_106M),
	.q(q_ram));
 */
				
endmodule