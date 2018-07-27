`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    ad7606 
//////////////////////////////////////////////////////////////////////////////////
module ad7606_qudong(
   input        		clk,                  //50mhz
	input        		rst_n,
	
	input [15:0] 		ad_data,            //ad7606 采样数据
	input        		ad_busy,            //ad7606 忙标志位
   input        		first_data,         //ad7606 第一个数据标志位  
	
	output [2:0] 		ad_os,              //ad7606 过采样倍率选择
	output reg   		ad_cs,              //ad7606 AD cs
	output reg   		ad_rd,              //ad7606 AD data read
	output reg   		ad_reset,           //ad7606 AD reset
	output reg   		ad_convstab,         //ad7606 AD convert start
	output				range,				//低电平 -5 ~ +5v
	
	
	output reg [15:0]   ad_ch1,              //AD第1通道的数据
	output reg [15:0]   ad_ch2,              //AD第2通道的数据
	output reg [15:0]   ad_ch3,              //AD第3通道的数据
	output reg [15:0]   ad_ch4,              //AD第4通道的数据
	output reg [15:0]   ad_ch5,              //AD第5通道的数据
	output reg [15:0]   ad_ch6,              //AD第6通道的数据
	output reg [15:0]   ad_ch7,              //AD第7通道的数据
	output reg [15:0]   ad_ch8,              //AD第8通道的数据	
	output reg  [3:0]  state
			
	//output reg [3:0] cnt
 
    );


assign		range = 1'b0;
reg [7:0] cnt = 0 ;
reg [15:0] cnt50us = 0;
reg [5:0] i;
//reg [3:0] state;

parameter IDLE=4'd0;
parameter AD_CONV=4'd1;
parameter Wait_1=4'd2;
parameter Wait_busy=4'd3;
parameter READ_CH1=4'd4;
parameter READ_CH2=4'd5;
parameter READ_CH3=4'd6;
parameter READ_CH4=4'd7;
parameter READ_CH5=4'd8;
parameter READ_CH6=4'd9;
parameter READ_CH7=4'd10;
parameter READ_CH8=4'd11;
parameter READ_DONE=4'd12;
//parameter display=4'd13;

assign ad_os=3'b000;  //无过采样

//ad复位
always@(posedge clk)
 begin
    if(cnt<8'hff) begin
        cnt<=cnt+1'b1;
        ad_reset<=1'b1;
      end
      else
        ad_reset<=1'b0;  //计数器达到ff后停止，ad_reset恒为零     
   end
	
//使用定时器来设置采样频率	200K采样率
always @(posedge clk or negedge rst_n) //每50us读取一次数据，ad的采样率为20K		//8
	begin
		if(rst_n == 0)
			cnt50us <= 0;
		else begin 				//20k	2499
			if(cnt50us < 16'd249)			//200k
				begin
					cnt50us <= cnt50us + 1'b1;
				end
			else
				cnt50us <= 0;
			end
	end

always @(posedge clk) 
 begin
	 if (ad_reset==1'b1) begin   //初始化ad
			 state<=IDLE; 
			 ad_ch1<=0;
			 ad_ch2<=0;
			 ad_ch3<=0;
			 ad_ch4<=0;
			 ad_ch5<=0;
			 ad_ch6<=0;
			 ad_ch7<=0;
			 ad_ch8<=0;
			 ad_cs<=1'b1;
			 ad_rd<=1'b1; 
			 ad_convstab<=1'b1;   //8通道同步采样
			 i<=0;
	 end		 
	 else begin
		  case(state)     //need time:(20+2+5+1+3*8+1)*20ns=1060ns, fmax=1/1060ns=1MHZ
		  IDLE: begin
				 ad_cs<=1'b1;
				 ad_rd<=1'b1; 
				 ad_convstab<=1'b1; 
				 if(i==20) begin        //延时20个时钟后开始转换
					 i<=0;			 
					 state<=AD_CONV;
				 end
				 else 
					 i<=i+1'b1;
		  end
		  AD_CONV: begin	   
				 if(i==2) begin                        //等待2个lock，convstab的下降沿最少为25ns，故至少需要两个时钟
					 i<=0;			 
					 state<=Wait_1;
					 ad_convstab<=1'b1;       				 
				 end
				 else begin
					 i<=i+1'b1;
					 ad_convstab<=1'b0;                     //启动AD转换
				 end
		  end
		  Wait_1: begin            
				 if(i==5) begin                           //等待5个clock, 等待busy信号为高(tconv)
					 i<=0;
					 state<=Wait_busy;
				 end
				 else 
					 i<=i+1'b1;
		  end		 
		  Wait_busy: begin            
				 if(ad_busy==1'b0) begin                    //等待busy为低电平  即转换之后读取模式
					 i<=0;			 
					 state<=READ_CH1;
				 end
		  end
		  READ_CH1: begin 
				 ad_cs<=1'b0;                              //cs信号有效  直到读取8通道结束
				 if(i==3) begin                            // 低电平持续3个时钟，完成通道1的读入
					 ad_rd<=1'b1;
					 i<=0;
					 ad_ch1<=ad_data;                        //读CH1
					 state<=READ_CH2;				 
				 end
				 else begin
					 ad_rd<=1'b0;	
					 i<=i+1'b1;
				 end
		  end
		  READ_CH2: begin 
				 if(i==3) begin
					 ad_rd<=1'b1;
					 i<=0;
					 ad_ch2<=ad_data;                        //读CH2
					 state<=READ_CH3;				 
				 end
				 else begin
					 ad_rd<=1'b0;	
					 i<=i+1'b1;
				 end
		  end
		  READ_CH3: begin 
				 if(i==3) begin
					 ad_rd<=1'b1;
					 i<=0;
					 ad_ch3<=ad_data;                        //读CH3
					 state<=READ_CH4;				 
				 end
				 else begin
					 ad_rd<=1'b0;	
					 i<=i+1'b1;
				 end
		  end
		  READ_CH4: begin 
				 if(i==3) begin
					 ad_rd<=1'b1;
					 i<=0;
					 ad_ch4<=ad_data;                        //读CH4
					 state<=READ_CH5;				 
				 end
				 else begin
					 ad_rd<=1'b0;	
					 i<=i+1'b1;
				 end
		  end
		  READ_CH5: begin 
				 if(i==3) begin
					 ad_rd<=1'b1;
					 i<=0;
					 ad_ch5<=ad_data;                        //读CH5
					 state<=READ_CH6;				 
				 end
				 else begin
					 ad_rd<=1'b0;	
					 i<=i+1'b1;
				 end
		  end
		  READ_CH6: begin 
				 if(i==3) begin
					 ad_rd<=1'b1;
					 i<=0;
					 ad_ch6<=ad_data;                        //读CH6
					 state<=READ_CH7;				 
				 end
				 else begin
					 ad_rd<=1'b0;	
					 i<=i+1'b1;
				 end
		  end
		  READ_CH7: begin 
				 if(i==3) begin
					 ad_rd<=1'b1;
					 i<=0;
					 ad_ch7<=ad_data;                        //读CH7
					 state<=READ_CH8;				 
				 end
				 else begin
					 ad_rd<=1'b0;	
					 i<=i+1'b1;
				 end
		  end
		  READ_CH8: begin 
				 if(i==3) begin
					 ad_rd<=1'b1;
					 i<=0;
					 ad_ch8<=ad_data;                        //读CH8
					 state<=READ_DONE;				 
				 end
				 else begin
					 ad_rd<=1'b0;	
					 i<=i+1'b1;
				 end
		  end
		  READ_DONE:begin                                 //完成读，回到idle状态
					 ad_rd<=1'b1;	 
					 ad_cs<=1'b1;
					 if(cnt50us == 16'd249)  					  //不加此条件，则ad完成一次读取需1280ns，采样频率781.25K，但需注意ad每通道的追高采样只能为200K
						state<=IDLE;
					else
						state<=READ_DONE;
		  end		
		  default:	state<=IDLE;
		  endcase	
    end	  
				 
 end

endmodule
