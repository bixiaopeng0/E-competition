/*-----------------------------------------------------------------------
* Date          :       2018/7/23 18:41:27  
* Version       :       1.0
* Description   :       Design for.
* --------------------------------------------------------------------*/

module  ad7606
(
    input        		clk,                  //50mhz
	input        		rst_n,
	
	input [15:0] 		ad_data,            //ad7606 ��������
	input        		ad_busy,            //ad7606 æ��־λ
    input        		first_data,         //ad7606 ��һ�����ݱ�־λ  
	
	output [2:0] 		ad_os,              //ad7606 ����������ѡ��
	output 		   		ad_cs,              //ad7606 AD cs
	output 		   		ad_rd,              //ad7606 AD data read
	output 		   		ad_reset,           //ad7606 AD reset
	output 		   		ad_convstab,         //ad7606 AD convert start
	output				range,				//�͵�ƽ -5 ~ +5v
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
	
	.ad_data			(ad_data		),            //ad7606 ��������
	.ad_busy			(ad_busy		),            //ad7606 æ��־λ
	.first_data			(first_data		),         //ad7606 ��һ�����ݱ�־λ  
	
	.ad_os				(ad_os			),              //ad7606 ����������ѡ��
	.ad_cs				(ad_cs			),              //ad7606 AD cs
	.ad_rd				(ad_rd			),              //ad7606 AD data read
	.ad_reset			(ad_reset		),           //ad7606 AD reset
	.ad_convstab		(ad_convstab	),         //ad7606 AD convert start
	.range				(range			),				//�͵�ƽ -5 ~ +5v
	
	
	.ad_ch1				(ad_ch1			),              //AD��1ͨ��������
	.ad_ch2				(ad_ch2			),              //AD��2ͨ��������
	.ad_ch3				(ad_ch3			),              //AD��3ͨ��������
	.ad_ch4				(ad_ch4			),              //AD��4ͨ��������
	.ad_ch5				(ad_ch5			),              //AD��5ͨ��������
	.ad_ch6				(ad_ch6			),              //AD��6ͨ��������
	.ad_ch7				(ad_ch7			),              //AD��7ͨ��������
	.ad_ch8				(ad_ch8			),              //AD��8ͨ��������	
	.state              (state			)
			
	//output reg [3:0] cnt
 
    );









endmodule





