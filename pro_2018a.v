/*-----------------------------------------------------------------------
* Date          :       2018/7/20 15:32:37  
* Version       :       1.0
* Description   :       Design for.
* --------------------------------------------------------------------*/

module  pro_2018a
(
        //clk   interface
        input                   clk                     ,       
        input                   rst_n                   ,      

       //ad     interface
    //    input       [ 9:0]      ad_data                 ,
    //    output                  ad_clk                  ,
		
		//switch interface
		input					sw						,
		
		//vga	interface
        //vga interface
        output                  vga_clk                 ,      
        output      [ 7:0]      vga_b                   ,
        output      [ 7:0]      vga_g                   ,
        output      [ 7:0]      vga_r                   ,
        output                  vga_blank               ,
        output                  vga_sync                ,
        output                  vga_hs                  ,
        output                  vga_vs                  ,
			
		//ad	interface
		input [15:0] 			ad_data,            //ad7606 采样数据
		input        			ad_busy,            //ad7606 忙标志位
		input        			first_data,         //ad7606 第一个数据标志位  
		
		output [2:0] 			ad_os,              //ad7606 过采样倍率选择
		output 		   			ad_cs,              //ad7606 AD cs
		output 		   			ad_rd,              //ad7606 AD data read
		output 		   			ad_reset,           //ad7606 AD reset
		output 		   			ad_convstab,         //ad7606 AD convert start
		output					range				//低电平 -5 ~ +5v
		
);


//--------------------------------
////Funtion : define

wire			[19:0]	xiebo1			; //基次谐波幅度
wire			[19:0]	xiebo2			; //谐波幅度
wire			[19:0]	xiebo3			; //谐波幅度
wire			[19:0]	xiebo4			; //谐波幅度
wire			[19:0]	xiebo5			; //谐波幅度
wire			[31:0]	f1				; //基波频率 和正弦信号
wire			[19:0]	a1				; //正弦电流峰峰值
wire					rdclock			; //vga时钟
wire			[12:0]	rd_ram			; //rd_ram地址
//wire			[ 9:0]	q_ram			; //ram读数据


//switch
wire			[19:0]	a1_vga			;
wire			[31:0]	f1_vga			;
wire			[19:0]	xiebo1_s		;
wire			[19:0]	xiebo2_s		; //谐波幅度
wire			[19:0]	xiebo3_s		; //谐波幅度
wire			[19:0]	xiebo4_s		; //谐波幅度
wire			[19:0]	xiebo5_s		; //谐波幅度

//--------------------------------
////Funtion :  display interface

T_0_top	vga_inst
(
					.clk	(clk			),
					.rst_n	(rst_n			),
					.zx_P	(f1_vga			),			//正弦波频率
					.zx_F	(a1_vga			),			//正弦波幅值
					.fzx_P	(f1_vga1		),		//非正弦波频率
					.fzx_F	(xiebo1			),		//非正弦波幅值
//					ram_data,
//					ram_addr,
					.fzx_2_F	(xiebo2		),		//二次谐波幅值
					.fzx_3_F	(xiebo3		),		//三次谐波幅值
					.fzx_4_F	(xiebo4		),		//四次谐波幅值
					.fzx_5_F	(xiebo5		),		//五次谐波幅值
					.switch		(sw			),
					
					.VGA_HS	(vga_hs		),
					.VGA_VS	(vga_vs		),
					.VGA_CLK (vga_clk	),
					.VGA_R	(vga_r		),
					.VGA_B	(vga_b		),
					.VGA_G	(vga_g		)
				);


//--------------------------------
////Funtion : fft interface



pro_fft		fft_inst
(
	//global clock
	.clk   			(clk		),			//system clock
	.rst_n 			(rst_n		),     		//sync reset
	
	//ad interface
//	.ad_data_in		(ad_data	),   	//
//	.ad_clk			(ad_clk		),
	
	.xiebo1			(xiebo1_s	),
	.xiebo2			(xiebo2_s	),
	.xiebo3			(xiebo3_s   ),
	.xiebo4			(xiebo4_s	),
	.xiebo5			(xiebo5_s	),
	.rdclock		(rdclock	),
	.rd_ram			(rd_ram		),
	//.q_ram			(q_ram		),
	.f1				(f1			),
	.a1_buchang		(a1			),
	.ad_ch1			(ad_ch1		)
	//key interface
//	input			[1:0]	key_data

	
);




//3

wire	[31:0]			f1_vga1			;
assign	f1_vga1 = (sw == 1'b1) ? 32'd0: f1; 
assign	f1_vga = (sw == 1'b1) ? f1 : 32'd0;
assign	a1_vga = (sw == 1'b1) ? a1 : 20'd0;

//4
assign	xiebo1 = (sw == 1'b0) ? xiebo1_s : 19'd0;
assign	xiebo2 = (sw == 1'b0) ? xiebo2_s : 19'd0;
assign	xiebo3 = (sw == 1'b0) ? xiebo3_s : 19'd0;
assign	xiebo4 = (sw == 1'b0) ? xiebo4_s : 19'd0;
assign	xiebo5 = (sw == 1'b0) ? xiebo5_s : 19'd0;


//--------------------------------
////Funtion : ad

wire		[15:0]		ad_ch1		;

ad7606
(
    .clk  				(clk			),                  //50mhz
	.rst_n				(rst_n			),
	
	.ad_data			(ad_data		),            //ad7606 采样数据
	.ad_busy			(ad_busy		),            //ad7606 忙标志位
    .first_data			(first_data		),         //ad7606 第一个数据标志位  
	
	.ad_os				(ad_os			),              //ad7606 过采样倍率选择
	.ad_cs				(ad_cs			),              //ad7606 AD cs
	.ad_rd				(ad_rd			),              //ad7606 AD data read
	.ad_reset			(ad_reset		),           //ad7606 AD reset
	.ad_convstab		(ad_convstab	),         //ad7606 AD convert start
	.range				(range			),				//低电平 -5 ~ +5v
	.ad_ch1				(ad_ch1			)
);
//--------------------------------
////Funtion : debug
/*
wire			flag			;

debug	debug_inst
(
    //clk interface
        .clk                     (clk		),      
        .rst_n                   (rst_n		),      
    //ram   interface
        .vga_clk                 (rdclock	),
        .rd_ram                  (rd_ram	),
        .q_ram                   (q_ram		),
        .flag					 (flag		)

);
*/




assign  vga_blank	=	vga_hs;
assign  vga_sync	=	vga_vs;




endmodule




