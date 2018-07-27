/*-----------------------------------------------------------------------
* Date          :       2018/7/23 18:41:27  
* Version       :       1.0
* Description   :       Design for.
* --------------------------------------------------------------------*/

module  ad7606
(
    input        		clk,                  //50mhz
	input        		rst_n,
	
	input [15:0] 		ad_data,            //ad7606 采样数据
	input        		ad_busy,            //ad7606 忙标志位
    input        		first_data,         //ad7606 第一个数据标志位  
	
	output [2:0] 		ad_os,              //ad7606 过采样倍率选择
	output 		   		ad_cs,              //ad7606 AD cs
	output 		   		ad_rd,              //ad7606 AD data read
	output 		   		ad_reset,           //ad7606 AD reset
	output 		   		ad_convstab,         //ad7606 AD convert start
	output				range,				//低电平 -5 ~ +5v
	output	[15:0]		ad_ch1
);




//wire			 [15:0]   			ad_ch1			;
wire			 [15:0]   			ad_ch2			;
wire			 [15:0]   			ad_ch3			;
wire			 [15:0]   			ad_ch4			;
wire			 [15:0]   			ad_ch5			;
wire			 [15:0]   			ad_ch6			;
wire			 [15:0]   			ad_ch7			;
wire			 [15:0]   			ad_ch8			;
wire			  [3:0]   			state			;



ad7606_qudong	qudong_inst
(
    .clk				(clk			),                  //50mhz
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
	
	
	.ad_ch1				(ad_ch1			),              //AD第1通道的数据
	.ad_ch2				(ad_ch2			),              //AD第2通道的数据
	.ad_ch3				(ad_ch3			),              //AD第3通道的数据
	.ad_ch4				(ad_ch4			),              //AD第4通道的数据
	.ad_ch5				(ad_ch5			),              //AD第5通道的数据
	.ad_ch6				(ad_ch6			),              //AD第6通道的数据
	.ad_ch7				(ad_ch7			),              //AD第7通道的数据
	.ad_ch8				(ad_ch8			),              //AD第8通道的数据	
	.state              (state			)
			
	//output reg [3:0] cnt
 
    );









endmodule





