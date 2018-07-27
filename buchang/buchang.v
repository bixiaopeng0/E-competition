/*-----------------------------------------------------------------------
* Date          :       2018/7/24 15:46:59 
* Version       :       1.0
* Description   :       Design for.
* --------------------------------------------------------------------*/

module  buchang
(

    //clk interface
        input                   clk                     ,      
        input                   rst_n                   ,      
    //f interface
        input       [31:0]      f1                      ,
        input       [19:0]      a1                      ,
    //buchang data
        output  reg [31:0]      a1_buchang              
);

//--------------------------------
////Funtion   data value

//wire        value1          ;//(>100mv) && (600hz ~ 800hz)
wire        value2          ;//(>100mv) && (800 ~ 1000hz)
wire        value3          ;//(>=40 <=100mv) && (>=900hz)
wire        value4          ;// >=40 <=100mv >=550 < 900
wire        value5          ; //>=40 <= 100 >= 480 < 550
wire        value6          ;//>= 10 < 40mv > 100 + 2.5mv 

//assign  value1 = (a1 > 1000 && f1 >= 6000 && f1 <= 8000) ? 1'b1 : 1'b0;
//assign  value2 = (a1 > 1000 && f1 >8000 ) ? 1'b1 : 1'b0;
//assign  value3 = (a1 >= 400 && a1 <= 1000 && f1 >= 9000) ? 1'b1 : 1'b0;
//assign  value4 = (a1 >= 400 && a1 <= 1000 && f1 >= 5500 && f1 < 9000) ? 1'b1 : 1'b0;
//assign  value5 = (a1 >= 400 && a1 <= 1000 && f1 >= 4800 && f1 < 5500) ? 1'b1 : 1'b0;
 
//assign  value6 = (a1>= 100 && a1 < 400 && f1 > 1000) ? 1'b1 : 1'b0;
//error

//--------------------------------
////Funtion :   >=100mv(1000) 600 ~ 800
// yinzi = (x/2000) - 2

reg          [3:0]       buchang_factor1                  ;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        buchang_factor1 <= 'd0;
    else if(value1)
        buchang_factor1 <= f1/2000 - 2'd2;
end

//yinzi2 = (x/1000)-6
reg         [3:0]       buchang_factor2                    ;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        buchang_factor2 <= 4'd0;
    else if(value2)
        buchang_factor2 <= f1/1000 - 3'd6;
end

//--------------------------------
////Funtion : CALculation

wire		value1								;
assign		value1 = (f1 >= 20'd9000 && f1 <= 20'd10000 && a1 >= 4'd10 && a1 <= 20'd8500) ? 1'b1 : 1'b0;


reg         [31:0]      a_buchang_temp          ;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        a_buchang_temp <= 'd0;
    else if(value1)
        a_buchang_temp <= (8'd100 + 2)*a1;
 /*   else if(value2)
        a_buchang_temp <= (8'd100 + buchang_factor2)*a1;
    else if(value3)
        a_buchang_temp <= (8'd100 + 3'd6)*a1;
    else if(value4)
        a_buchang_temp <= (8'd100 + 3'd4)*a1;
    else if(value5)
        a_buchang_temp <= (8'd100 + 3'd3)*a1;*/
  //  else if(value6)
   //     a_buchang_temp <= (a1 + 5'd25)*8'd100;
    else
        a_buchang_temp <= a1 * 8'd100;
end


always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        a1_buchang <=  32'd0;
    else
        a1_buchang <= a_buchang_temp / 8'd100;
end
















endmodule





