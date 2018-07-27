module	T_0_top(
					clk,
					rst_n,
					zx_P,			//正弦波频率
					zx_F,			//正弦波幅值
					fzx_P,		//非正弦波频率
					fzx_F,		//非正弦波幅值
//					ram_data,
//					ram_addr,
					fzx_2_F,		//二次谐波幅值
					fzx_3_F,		//三次谐波幅值
					fzx_4_F,		//四次谐波幅值
					fzx_5_F,		//五次谐波幅值
					switch,
					//clk_106M,
					//q_ram,
					//rd_ram,
					
					VGA_HS,
					VGA_VS,
					VGA_CLK,
					VGA_R,
					VGA_B,
					VGA_G
				);
			//output 	[9:0]		rd_ram;	
			//input	[9:0]		q_ram;
			input 				clk;
			input					rst_n;
			input					switch;
			input	[15:0]		zx_P;			//正弦信号频率
			input	[15:0]		zx_F;			//正弦信号幅值
			input	[15:0]		fzx_P;		//非正弦信号频率
			input	[15:0]		fzx_F;		//非正弦信号幅值
//			input	[9:0]			ram_data;
//			input	[9:0]			ram_addr;
			input	[15:0]		fzx_2_F;		//非正弦信号2次谐波幅值
			input	[15:0]		fzx_3_F;		//非正弦信号3次谐波幅值
			input	[15:0]		fzx_4_F;		//非正弦信号4次谐波幅值
			input	[15:0]		fzx_5_F;		//非正弦信号5次谐波幅值
				
			output	[7:0]		VGA_R;			
			output	[7:0]		VGA_G;		
			output	[7:0]		VGA_B;
			output				VGA_CLK;	
			output				VGA_HS;
			output				VGA_VS;
			//output				clk_106M;		
					
					
			wire	     			clk_106M;
			wire					en;
			wire	[10:0]		en1;	
			wire	[10:0]		en2;
			wire	[63:0]		Rom_Data_h;
			wire	[63:0]		Rom_Data_d;
			wire	[63:0]		Rom_Data_s;	
			wire	[9:0]			Rom_Data_ceshi;
			
			wire	[8:0]			Rom_Addr_s;
			wire	[7:0]			Rom_Addr_d;
			wire	[9:0]			Rom_Addr_h;	
			wire	[9:0]			Rom_Addr_ceshi;
			
			wire	[9:0]			rd_ram;
			
			
			
			PLL_106M_0002 PLL_106M_0002_inst(
					.refclk(clk),
					.rst(~rst_n),
					.outclk_0(clk_106M),
					.locked()
					);					
				
		r_g_b		r_g_b_inst(	
					.clk(clk_106M),
					.rst_n(rst_n),
					.en(en),		//使能信号
					.en1(en1),  //列，X
					.en2(en2),	//行，Y
					.Rom_Data_h(Rom_Data_h),
					.Rom_Data_d(Rom_Data_d),	
					.Rom_Data_s(Rom_Data_s),
					//.rd_ram(rd_ram),
					//.Rom_Data_ceshi(Rom_Data_ceshi),
					.zx_P(zx_P),			//正弦信号频率
					.zx_F(zx_F),			//正弦信号幅值
					.fzx_P(fzx_P),		//非正弦信号频率
					.fzx_F(fzx_F),		//非正弦信号幅值
			//		.ram_data,
			//		.ram_addr,
					.fzx_2_F(fzx_2_F),		//非正弦信号2次谐波幅值
					.fzx_3_F(fzx_3_F),		//非正弦信号3次谐波幅值
					.fzx_4_F(fzx_4_F),		//非正弦信号4次谐波幅值
					.fzx_5_F(fzx_5_F),		//非正弦信号5次谐波幅值
				
					.Rom_Addr_s(Rom_Addr_s),
					.Rom_Addr_d(Rom_Addr_d),
					.Rom_Addr_h(Rom_Addr_h),
					.switch(switch),
					//.Rom_Addr_ceshi(Rom_Addr_ceshi),
					//.q_ram(q_ram),
					.VGA_R(VGA_R),			
					.VGA_G(VGA_G),		
					.VGA_B(VGA_B),
					.addRomTitle(title_addr),
					.dataRomTitle(title_data)
			);		

			
			vga	vga_inst(
					.clk(clk_106M),
					.rst_n(rst_n),
				
					.VGA_HS(VGA_HS),		//列同步信号
					.VGA_VS(VGA_VS),		//行同步信号
					.en(en),
					.en1(en1),
					.en2(en2),
					.VGA_CLK(VGA_CLK)
		);
		wire	[7:0]		title_addr		;
		wire	[63:0]		title_data		;
	title title_inst(
	.address(title_addr),
	.clock(clk_106M),
	.q(title_data)
	);
		
			danwei1_rom danwei1_rom_inst(
					.address(Rom_Addr_d),
					.clock(clk_106M),
					.q(Rom_Data_d)
					);
							
			shuzi1_rom shuzi1_rom_inst(
					.address(Rom_Addr_s),
					.clock(clk_106M),
					.q(Rom_Data_s)
					);
					
			hanzi1_rom hanzi1_rom_inst(
					.address(Rom_Addr_h),
					.clock(clk_106M),
					.q(Rom_Data_h)
					);
					

		

				
endmodule