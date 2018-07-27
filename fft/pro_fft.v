/*-----------------------------------------------------------------------

Date				:		2017-07-30
Description			:		Design for fft cepin cefu.

-----------------------------------------------------------------------*/

module pro_fft
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//ad interface
//	input			[9:0]	ad_data_in,   	//
//	output					ad_clk,
	input			[15:0]	ad_ch1,
	//key interface
//	input			[1:0]	key_data
	output			[19:0]	xiebo1,
	output			[19:0]	xiebo2,
	output			[19:0]	xiebo3,
	output			[19:0]	xiebo4,
	output			[19:0]	xiebo5,
	input					rdclock,
	input			[12:0]	rd_ram,
	//output			[ 9:0]	q_ram,
	
	output			[31:0]	f1	,
	output			[19:0]	a1_buchang	
	
); 

	
//--------------------------------
//Funtion : ad 数据产生	


wire		[15:0]			ad_data_4k			;

ad_crtl	ad_inst
(
	//global clock
	.	clk(clk),			//system clock
	.	rst_n(rst_n),     		//sync reset
	
	//ad_in interface
	.	ad_data_in(ad_ch1),   	//
	.	sample_clk(sample_clk),
	
	//user interface

	.	ad_data(ad_data_4k)		//
	
); 	
	
//--------------------------------
//Funtion : 单个按键的驱动	
wire					sample_clk;

sample_clk			sample_clk_inst
(
	//global clock
	.	clk(clk),			//system clock
	.	rst_n(rst_n),     		//sync reset
	
	//key interface
	//.	key0_value(key0_value),
	//sample_clk interface

	.	sample_clk(sample_clk)
	
); 

//--------------------------------
//Funtion : FFT	IP
	wire			inverse = 1'b0;	//0       //input
	wire			sink_valid;               //input
	wire			sink_sop;                 //input
	wire			sink_eop;                 //input
	//wire	[9:0]	sink_real;                //input
	wire	[15:0]	sink_imag = 16'd0;        //input
	wire	[1:0]	sink_error;               //input
	wire			source_ready = 1'd1;			  //input
	wire			sink_ready;
	wire	[1:0]	source_error;
	wire			source_sop;
	wire			source_eop;
	wire			source_valid;
	wire	[5:0]	source_exp;
	wire	[15:0]	source_real;
	wire	[15:0]	source_imag;


fft_4096 			fft_inst
(
	.	clk(clk),
	.	reset_n(rst_n),
	.	inverse(inverse),
	.	sink_valid(sink_valid),
	.	sink_sop(sink_sop),
	.	sink_eop(sink_eop),
	.	sink_real(q),
	.	sink_imag(sink_imag),
	.	sink_error(sink_error),
	.	source_ready(source_ready),
	.	sink_ready(sink_ready),
	.	source_error(source_error),
	.	source_sop(source_sop),
	.	source_eop(source_eop),
	.	source_valid(source_valid),
	.	source_exp(source_exp),
	.	source_real(source_real),
	.	source_imag(source_imag)
);


//--------------------------------
//Funtion : fifo IP
	wire					rd_fifo_en;    //input
	wire	 				wr_fifo_en;    //input
	wire			[15:0] 	q;
	wire	  				rdempty;
	wire	  				wrfull;


 fifo_4096 fifo_inst
 (     
	.	data(ad_data_4k),              //input
	.	rdclk(clk),             //input
	.	rdreq(rd_fifo_en),             //input
	.	wrclk(sample_clk),             //input
	.	wrreq(wr_fifo_en),             //input
	.	q(q),
	.	rdempty(rdempty),
	.	wrfull(wrfull)
);

//--------------------------------
//Funtion : fifo control
//wire			[12:0]	q_sig;
fifo_control	fifo_control_inst
(
	//global clock
	.	clk(clk),			//system clock
	.	rst_n(rst_n),     		//sync reset
	
	//fifo interface
	.	rd_fifo_en(rd_fifo_en),    
	.	wr_fifo_en(wr_fifo_en),    
	.	rdempty(rdempty),
	.	wrfull(wrfull),
	
	//fft	interface
	.	sink_ready(sink_ready),
	.	sink_sop(sink_sop),
	.	sink_eop(sink_eop),
	.	sink_valid(sink_valid)
	
); 

//--------------------------------
//Funtion : fft_control
//wire		[11:0]		rd_ram;
wire		[12:0]		wr_ram;
wire					wren;
//wire		[9:0]		q_ram;
//wire		[9:0]		data;		
wire		[16:0]		q_sig;
fft_control		fft_control_inst
(
	//global clock
	.	clk(clk),			//system clock
	.	rst_n(rst_n),     		//sync reset
	
	//fft interface
	.	source_sop(source_sop),
	.	source_valid(source_valid),
	.	source_real(source_real),
	.	source_imag(source_imag),

	.	wr_ram(wr_ram),
	.	rd_ram(rd_ram),
	.	rdclock(rdclock),
	.	wren(wren),
//	.	q_ram(q_ram),
	//.	data(data),
	.	q_sig(q_sig)
	//.	q_sig({3'd0,data})
); 


wire		[31:0]			a1			;
assign		a1_buchang =    a1			;

//补偿
/*buchang		buchang_inst
(

    //clk interface
        .clk                     (clk		),      
        .rst_n                   (rst_n		),      
    //f interface
        .f1                      (f1		),
        .a1                      (a1		),
    //buchang data
        .a1_buchang              (a1_buchang)
);
*/

//--------------------------------
//Funtion : fft_control

cepin		cepin_inst
(
	//global clock
	.	clk(clk),			//system clock
	.	rst_n(rst_n),     		//sync reset
	
	//samclk  interface
	//.	key_data(key_data),

	//ram  interface	
	.	wr_ram(wr_ram),
	
	.	q_sig(q_sig),
	.	source_exp(source_exp),
	
	//pinlv interface

	.	f1(f1),		//
	.	a1(a1),
	.	xiebo1(xiebo1),
	.   xiebo2(xiebo2),
	.   xiebo3(xiebo3),
	.   xiebo4(xiebo4),
	.   xiebo5_buchang(xiebo5)	

);
	
	
endmodule
	
