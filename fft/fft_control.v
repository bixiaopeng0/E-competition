/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for fft_control.

-----------------------------------------------------------------------*/

module fft_control
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//fft interface
	input					source_sop,
	input					source_valid,
	input			[15:0]	source_real,
	input			[15:0]	source_imag,
	
	//ram	interface
	input			[12:0]	rd_ram,
	input					rdclock,
	output			[12:0]	wr_ram,
	output					wren,
//	output			[9:0]	q_ram,
//	output			[9:0]	data,		//位宽可能溢出  确实溢出了13bit jj 
	output			[16:0]	q_sig
	//output			[12:0]	q_sig //开根号之后的数据
); 


//wire		[12:0]		q_sig		;//


//--------------------------------
//Funtion :    数据处理           
wire		[31:0]		result_real;
wire		[31:0]		result_image;

mul_10	mul_real (
	.dataa ( source_real ),
	.result ( result_real )
	);
	
mul_10	mul_image (
	.dataa ( source_imag ),
	.result ( result_image )
	);

reg		[32:0]		result_add;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		result_add <= 32'd0;
	else
		result_add <= result_real + result_image;
end

//wire	[12:0]		q_sig;
	
sqrt	sqrt_inst (
	.radical ( result_add ),
	.q ( q_sig )
	//.remainder ( remainder_sig )
	);


	
//assign		data =  (wr_ram1 > 4'd9) ? q_sig[9:0] : 'd0;
//--------------------------------
//Funtion :   写地址
reg		[12:0]		wr_ram1;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		wr_ram1 <= 12'd0;
	else if(wren)
		wr_ram1 <= wr_ram1 + 1'd1;
	else
		wr_ram1 <= 1'd0;
end
//消除开始的直流分量  
assign	wr_ram	= (wr_ram1 > 2'd3) ? wr_ram1 - 2'd1 : 1'b0;
 
  
/*
ram_1024x4096 	ram_isnt(
	.wrclock(clk),
	.rdclock(rdclock),
	.data(data),
	.rdaddress(rd_ram),
	.wraddress(wr_ram),
	.wren(wren),
	.q(q_ram)
	);
*/
assign		wren = source_valid;

endmodule
	
