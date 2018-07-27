/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for fifo_control.

-----------------------------------------------------------------------*/

module fifo_control
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//fifo interface
	output	reg				rd_fifo_en,    
	output	reg		 		wr_fifo_en,    
	input	  				rdempty,
	input	  				wrfull,
	
	//fft	interface
	input					sink_ready,
	output					sink_sop,
	output					sink_eop,
	output					sink_valid
	
); 


//--------------------------------
//Funtion :   读数据计数  4096          
reg			[12:0]		read_cnt;


always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		read_cnt <= 13'd0;
	else if(rd_fifo_en)
		read_cnt <= read_cnt + 1'b1;
	else
		read_cnt <= 13'd0;
end

//--------------------------------
//Funtion :   fifo 读使能
reg				state_fifo;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		state_fifo <= 1'd0;
		rd_fifo_en <= 1'b0;
		wr_fifo_en <= 1'b0;
	end
	else
		case(state_fifo)
		
		//写fifo
		1'd0 :
		begin
			if(wrfull && sink_ready)
			begin
				rd_fifo_en <= 1'b1;
				wr_fifo_en <= 1'b0;
				state_fifo <= 1'b1;
			end
			else
			begin
				rd_fifo_en <= 1'b0;
				wr_fifo_en <= 1'b1;
				state_fifo <= 1'b0;
			end
		end
		
		//读fifo
		1'd1 :
		begin
			if(rdempty)
			begin
				rd_fifo_en <= 1'b0;
				wr_fifo_en <= 1'b1;
				state_fifo <= 1'b0;
			end
			else
			begin
				rd_fifo_en <= 1'b1;
				wr_fifo_en <= 1'b0;
				state_fifo <= 1'b1;
			end
		end
		
		default : ;
		
		endcase
end


/* always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		rd_fifo_en <= 1'd0;
	else if(wrfull && sink_ready)
		rd_fifo_en <= 1'd1;
	else if(rdempty)
		rd_fifo_en <= 1'd0;
	else
		rd_fifo_en <= rd_fifo_en;
end

//--------------------------------
//Funtion :   fifo 写使能

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		wr_fifo_en <= 1'd1;
	else if(rdempty)
		wr_fifo_en <= 1'd1;
	else if(wrfull)
		wr_fifo_en <= 1'd0;
	else
		wr_fifo_en <= wr_fifo_en;
end */



//--------------------------------
//Funtion :   sink_sop sink_eop
assign		sink_sop = (read_cnt == 1'b1) ? 1'b1 : 1'b0;
assign		sink_eop = (read_cnt == 13'd8191) ? 1'b1 : 1'b0;




assign		sink_valid = rd_fifo_en;

endmodule
	
