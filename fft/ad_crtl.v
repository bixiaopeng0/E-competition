/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for LCD1602 Display.

-----------------------------------------------------------------------*/

module ad_crtl
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//ad_in interface
	input			[15:0]	ad_data_in,   	//
	input					sample_clk,
	//user interface

	output	reg		[15:0]	ad_data		//
); 


//--------------------------------
//Funtion :      ad数据产生         




always @(posedge sample_clk or negedge rst_n)
begin
	if(!rst_n)
		ad_data <= 'd0;
	else
		ad_data <= ad_data_in; //转换成有符号
end


endmodule
	
