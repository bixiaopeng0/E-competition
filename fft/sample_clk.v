/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for 频率分辨率.

-----------------------------------------------------------------------*/

module sample_clk
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//key interface
//	input					key0_value,
//	input		[1:0]		key_data,
	//sample_clk interface

	output	reg				sample_clk
	
); 


//--------------------------------
//Funtion :               

	
/* always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		key_data <= 2'd0;
	else if(key0_value)
		key_data <= key_data + 1'b1;
end */


//--------------------------------
//Funtion :   分频
reg			[15:0]			n;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		n <= 16'd0;
	else 
		//n <= 16'd12207;			//分辨率0.5HZ
		n <= 16'd6103;		//分辨率1HZ  4096HZ
		
end

//--------------------------------
//Funtion :   sample_clk
reg			[15:0]		cnt_clk;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_clk <= 16'd0;
	else if(cnt_clk >= n - 1'b1)
		cnt_clk <= 16'd0;
	else
		cnt_clk <= cnt_clk + 1'b1;
end		
		
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		sample_clk <= 1'b0;
	else if(cnt_clk >= n - 1'b1)
		sample_clk <= ~sample_clk;
	else
		sample_clk <= sample_clk;
end



endmodule
	
