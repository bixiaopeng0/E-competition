/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for fft cepin.

-----------------------------------------------------------------------*/

module cepin
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//samclk  interface
	//input			[1:0]	key_data,
	
	//sqrt		interface
	
	input			[16:0]	q_sig,
	
	//fft	  interface
	input			[5:0]	source_exp,	  
	
	//ram  interface	
	input			[12:0]	wr_ram,
	
	//pinlv interface

	output	reg		[31:0]	f1,		//
	output	reg		[19:0]	a1,
	
	//谐波
	output	reg		[19:0]	xiebo1,
	output	reg		[19:0]	xiebo2,
	output	reg		[19:0]	xiebo3,
	output	reg		[19:0]	xiebo4,
	output	reg		[19:0]	xiebo5_buchang,
	//debug
	output	reg		[1:0]	state_fft
	
); 


reg			[16:0]		x1		;
reg			[16:0]		x2		;
reg			[16:0]		x3		;
reg			[16:0]		x4		;
reg			[16:0]		x5		;

reg			[19:0]		xiebo5	;



//--------------------------------
//Funtion :  pinlv1分辨率
/*reg			[15:0]		fp;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		fp <= 16'd0;
	else
		fp <= 16'd1;*/
	//	case(key_data)
	//	2'b00 : fp <= 16'd1;
	//	2'b01 : fp <= 16'd10;
	//	2'b10 : fp <= 16'd100;
	//	2'b11 : fp <= 16'd1000;
	//	default : ;
	//	endcase
//end


//--------------------------------
//Funtion :  比较
reg			[16:0]		temp1;
reg			[16:0]		temp2;
reg			[16:0]		temp3;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		temp1 <= 17'd0;
		temp2 <= 17'd0;
		temp3 <= 17'd0;
	end
	else
	begin
		temp1 <= q_sig;
		temp2 <= temp1;
		temp3 <= temp2;
	end
end


//--------------------------------
//Funtion :  测频状态机

//reg			[1:0]		state_fft;
reg			[17:0]		a_temp;
reg			[31:0]		f_temp;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		state_fft <= 2'd0;
		a_temp    <= 16'd0;
		f_temp    <= 32'd0;
	end
	else
		case(state_fft)
	//因为FFT频域是对称分布的，所以只测正半周期即可
		
		3'd0 :
		begin
			if( wr_ram <= 6'd18 ||wr_ram > 13'd4095)
			//if(wr_ram > 13'd2048 || wr_ram <= 6'd18 )
			begin
				state_fft <= 2'd0;
				f_temp    <= 32'd0;
				a_temp	  <= 13'd0;
			end
			else
				state_fft <= 2'd1;
		end
		
		3'd1 :
		begin
			if(wr_ram < 13'd4095)
			begin
				state_fft <= 2'd1;
				if((temp2 >temp1)  && (temp2 > temp3))
				begin
					if(temp2 > a_temp)
					begin
						f_temp <= wr_ram;
						a_temp <= temp2;
					end
				end
			end
			else if(wr_ram == 13'd4095)		//2k
				state_fft <= 2'd2;
		end
		
		3'd2 :
		begin
			state_fft <= 2'd0;
		end
		
		default : ;
		endcase
end


//--------------------------------
//Funtion :  0.5S稳定

/* parameter		HALF_S = 32'd25_000_000;

reg			[31:0]		cnt_s;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_s <= 32'd0;
	else if(cnt_s == HALF_S - 1'b1)
		cnt_s <= 32'd0;
	else
		cnt_s <= cnt_s + 1'b1;
end

reg			[11:0]		a_temp1;
reg			[31:0]		f_temp1;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		a_temp1 <= 12'd0;
		f_temp1 <= 32'd0;
	end
	else if(cnt_s == HALF_S - 1'b1)
	begin
		a_temp1 <= a_temp;
		f_temp1 <= f_temp;
	end
end */

reg		[ 5:0]			source_exp_temp		;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		source_exp_temp <= 'd0;
	else if(state_fft == 2'd2)
		source_exp_temp <= source_exp;
end

reg		[31:0]			f1_temp				;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		f1_temp <= 'd0;
	else if(state_fft == 3'd2)
		f1_temp <= f_temp - 3'd2;
end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		f1 <= 32'd0;
	else if(state_fft == 3'd2)
		f1 <= (f_temp  - 3'd2)*5;  //实际频率*10
end

/*
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		a1 <= 12'd0;
	else if(source_exp == 6'd53 && state_fft == 3'd2)
		a1 <= a_temp << 2'd2;
	else if(source_exp == 6'd54 && state_fft == 3'd2)
		a1 <= a_temp << 1'd1;
end
*/

//--------------------------------
//Funtion :  测量谐波

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		x1 <= 17'd0;
		x2 <= 17'd0;
		x3 <= 17'd0;
		x4 <= 17'd0;
		x5 <= 17'd0;
	end
	else
	begin
		if(state_fft == 3'd2)
			x1 <= a_temp;
		if(wr_ram == (f1_temp<<1))
			x2 <= q_sig;
		if(wr_ram == (f1_temp*3))
			x3 <= q_sig;
		if(wr_ram == (f1_temp<<2))
			x4 <= q_sig;
		if(wr_ram == (f1_temp*5))
			x5 <= q_sig;
	end
end



//--------------------------------
//Funtion :  拟合数据
wire		[19:0]	   		a1_nihe						;
wire		[19:0]	   		xiebo2_nihe					;
wire		[19:0]	   		xiebo3_nihe					;
wire		[19:0]	   		xiebo4_nihe					;
wire		[19:0]	   		xiebo5_nihe					;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		a1 <= 'd0;
		xiebo1 <= 'd0;
		xiebo2 <= 'd0;
		xiebo3 <= 'd0;
		xiebo4 <= 'd0;
		xiebo5 <= 'd0;
	end
	else
	begin
		if(x1 == 1'd0)
		begin
			xiebo1 <= 'd0;
			a1 <= 'd0;
		end
		else
		begin
			xiebo1 <= (a1_nihe >> 2'd2);
			a1 <= (a1_nihe >> 2'd1);
		end	
		
		if(x2 == 1'b0)
			xiebo2 <= 'd0;
		else
			xiebo2 <= (xiebo2_nihe >> 2'd2);
		
		if(x3 == 1'b0)
			xiebo3 <= 'd0;
		else
			xiebo3 <= (xiebo3_nihe >> 2'd2);
		
		if(x4 == 1'b0)
			xiebo4 <= 'd0;
		else
			xiebo4 <= (xiebo4_nihe >> 2'd2);
		
		if(x5 == 1'b0)
			xiebo5 <= 'd0;
		else
			xiebo5 <= (xiebo5_nihe >> 2'd2);
	end
end


//补偿谐波5
reg			[31:0]		xiebo5_temp			;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		xiebo5_temp <= 32'd0;
	else
		xiebo5_temp <= (8'd103)*xiebo5;
end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		xiebo5_buchang <= 32'd0;
	else
		xiebo5_buchang <= xiebo5_temp / 8'd100;
end

 cefu		cefu_jibo
(
    //clk   interface
        .clk                     (clk		),      
        .rst_n                   (rst_n		),      
    //cefu  interface            ()
        .v_data                  (a1_nihe	),
        .q_sig                   (x1		),
        .source_exp  			 (source_exp_temp)
);  

 cefu		cefu_xiebo2
(
    //clk   interface
        .clk                     (clk		),      
        .rst_n                   (rst_n		),      
    //cefu  interface            ()
        .v_data                  (xiebo2_nihe),
        .q_sig                   (x2		),
        .source_exp  			 (source_exp_temp)
); 

 cefu		cefu_xiebo3
(
    //clk   interface
        .clk                     (clk		),      
        .rst_n                   (rst_n		),      
    //cefu  interface            ()
        .v_data                  (xiebo3_nihe),
        .q_sig                   (x3		),
        .source_exp  			 (source_exp_temp)
); 

 cefu		cefu_xiebo4
(
    //clk   interface
        .clk                     (clk		),      
        .rst_n                   (rst_n		),      
    //cefu  interface            ()
        .v_data                  (xiebo4_nihe),
        .q_sig                   (x4		),
        .source_exp  			 (source_exp_temp)
); 

 cefu		cefu_xiebo5
(
    //clk   interface
        .clk                     (clk		),      
        .rst_n                   (rst_n		),      
    //cefu  interface            ()
        .v_data                  (xiebo5_nihe),
        .q_sig                   (x5		),
        .source_exp  			 (source_exp_temp)
); 

endmodule 
