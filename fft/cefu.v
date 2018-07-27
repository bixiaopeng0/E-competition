/*-----------------------------------------------------------------------
* Date          :       2018/7/21 15:00:50  
* Version       :       1.0
* Description   :       Design for.
* --------------------------------------------------------------------*/

module  cefu
(
    //clk   interface
        input                   clk                     ,      
        input                   rst_n                   ,      
    //cefu  interface
        output reg     [19:0]   v_data                  ,
        input          [17:0]   q_sig                   ,
        input          [ 5:0]   source_exp  
);  


//--------------------------------
////Funtion : 
reg           [31:0]            x                   ;       
reg           [31:0]            x1                  ;
reg			  [31:0]			x2					;

reg           [ 5:0]            move_number         ;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        move_number <= 6'd0;
    else if(source_exp[5] == 1'b1)
        move_number <= ~source_exp + 1'b1;
    else
        move_number <= source_exp;
end




always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        x <= 32'd0;
    else if(source_exp[5] == 1'b1)
        x <= (q_sig << move_number);
    else
        x <= (q_sig >> move_number);
end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		x1 <= 32'd0;
	else	
		x1 <= x*6'd50;
		//x1 <= (x >> 4'd15);
end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		x2 <= 32'd0;
	else	
		x2 <= (x1 >> 4'd15);
end



//未除2分之N的数据
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		v_data <= 32'd0;
	else
		v_data <= x2;
end

/*
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        x1 <= 32'd0;
    else
        x1 <= x;//{x - 10'd512};	直流分量
end


//数据放大10倍

reg		[35:0]		x2_temp;

reg		[31:0]		x2;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		x2_temp <= 35'd0;
	else
		x2_temp <= (x1 << 3'd3) + (x1 << 3'd1);
end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		x2 <= 'd0;
	else
		x2 <= x2_temp[31:0];
end

//除512

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        v_data <= 'd0;
    else 
        v_data <= (x2 >> 4'd9);
end



*/



endmodule





