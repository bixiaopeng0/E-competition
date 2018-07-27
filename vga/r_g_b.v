module r_g_b(
			
			input 			clk,
			input				rst_n,
			input	  			en,		//使能信号
			input [10:0]	en1,  //列，X
			input [10:0]	en2,	//行，Y
			input	[63:0]		Rom_Data_h,
			input	[63:0]		Rom_Data_d,	
			input	[63:0]		Rom_Data_s,
			//——————————————————————
			input	[63:0]		dataRomTitle,									//标题数据
			output	reg[7:0]			addRomTitle,							//标题地址
			//input	[9:0]			Rom_Data_ceshi,
			//input	[9:0]			q_ram,
			input					switch,
			
			input	[15:0]		zx_P,			//正弦信号频率
			input	[15:0]		zx_F,			//正弦信号幅值
			input	[15:0]		fzx_P,		//非正弦信号频率
			input	[15:0]		fzx_F,		//非正弦信号幅值
//			input	[9:0]			ram_data,
//			input	[9:0]			ram_addr,
			input	[15:0]		fzx_2_F,		//非正弦信号2次谐波幅值
			input	[15:0]		fzx_3_F,		//非正弦信号3次谐波幅值
			input	[15:0]		fzx_4_F,		//非正弦信号4次谐波幅值
			input	[15:0]		fzx_5_F,		//非正弦信号5次谐波幅值
						
			output	[8:0]		Rom_Addr_s,
			output	[7:0]		Rom_Addr_d,
			output 	[9:0]		Rom_Addr_h,
			//output	[9:0]		rd_ram,
			
			//output	[9:0]		Rom_Addr_ceshi,
			output	[7:0]		VGA_R,			
			output	[7:0]		VGA_G,		
			output	[7:0]		VGA_B				
			);					
			
			wire		[15:0]		fzx_2_P = 4'd2 * fzx_P;//二次谐波频率display_h_0
			wire		[15:0]		fzx_3_P = 4'd3 * fzx_P;//三次谐波频率display_h_1
			wire		[15:0]		fzx_4_P = 4'd4 * fzx_P;//四次谐波频率display_h_2
			wire		[15:0]		fzx_5_P = 4'd5 * fzx_P;//五次谐波频率display_h_3

			
			
//——————————————————————————————————————————————————————		

wire	display_t_0 = (en2 >= 'd0+ 4'd10&& en2 <= 'd32 + 4'd10) && (en1 >= 'd464 && en1 <= 'd528);//电
wire	display_t_1 = (en2 >= 'd0+ 4'd10&& en2 <= 'd32 + 4'd10) && (en1 >= 'd528 && en1 <= 'd592);//流
wire	display_t_2 = (en2 >= 'd0+ 4'd10&& en2 <= 'd32 + 4'd10) && (en1 >= 'd592 && en1 <= 'd656);//信
wire	display_t_3 = (en2 >= 'd0+ 4'd10&& en2 <= 'd32 + 4'd10) && (en1 >= 'd656 && en1 <= 'd720);//号
wire	display_t_4 = (en2 >= 'd0+ 4'd10&& en2 <= 'd32 + 4'd10) && (en1 >= 'd720 && en1 <= 'd784);//检
wire	display_t_5 = (en2 >= 'd0+ 4'd10&& en2 <= 'd32 + 4'd10) && (en1 >= 'd784 && en1 <= 'd848);//测
wire	display_t_6 = (en2 >= 'd0+ 4'd10&& en2 <= 'd32 + 4'd10) && (en1 >= 'd848 && en1 <= 'd912);//装
wire	display_t_7 = (en2 >= 'd0+ 4'd10&& en2 <= 'd32 + 4'd10) && (en1 >= 'd912 && en1 <= 'd976);//置

wire	[7:0] display_value_t = {display_t_0, display_t_1, display_t_2,display_t_3 ,display_t_4,display_t_5,display_t_6,display_t_7};

always @ (posedge clk or negedge rst_n)	begin
	if(!rst_n)
		addRomTitle <= 'd0;
	else 
		case(display_value_t)
			8'b1000_0000:addRomTitle <= en2			- 4'd10	;
			8'b0100_0000:addRomTitle <= en2 + 32	- 4'd10	;
			8'b0010_0000:addRomTitle <= en2 + 64	- 4'd10	;
			8'b0001_0000:addRomTitle <= en2 + 96	- 4'd10	;
			8'b0000_1000:addRomTitle <= en2 + 128	- 4'd10	;
			8'b0000_0100:addRomTitle <= en2 + 160	- 4'd10	;
			8'b0000_0010:addRomTitle <= en2 + 192	- 4'd10	;
			8'b0000_0001:addRomTitle <= en2 + 224	- 4'd10	;
		default: addRomTitle <= 'd0;
		endcase
end

reg	[11:0]	lie;
always @ (posedge clk or negedge rst_n)	begin
	if(!rst_n)
		lie <= 'd0;
	else 
		case(display_value_t)
			8'b1000_0000:lie <= en1 - 'd464;
			8'b0100_0000:lie <= en1 - 'd528;
			8'b0010_0000:lie <= en1 - 'd592;
			8'b0001_0000:lie <= en1 - 'd656;
			8'b0000_1000:lie <= en1 - 'd720;
			8'b0000_0100:lie <= en1 - 'd784;
			8'b0000_0010:lie <= en1 - 'd848;
			8'b0000_0001:lie <= en1 - 'd912;
		endcase
end

reg vga_r_t;
reg vga_g_t;
reg vga_b_t;
always @(posedge clk or negedge rst_n)
	begin	
		if (!rst_n)
			begin
					vga_r_t <= 1'b0;
					vga_g_t <= 1'b0;
					vga_b_t <= 1'b0;			
			end								
		else if (display_value_t)			/////更改此处控制显示位置							
			begin
					vga_r_t <= dataRomTitle[63 - lie];
					vga_g_t <= dataRomTitle[63 - lie];
					vga_b_t <= dataRomTitle[63 - lie];			
			end
	end	

 wire		display_title =  (vga_r_t && vga_g_t && vga_b_t);
//————————————————————————————————————————————		
 
parameter	XIAYICANSHU = 10'd896 - 10'd281 - 10'd10;
///////////////////////////////////////////////////////////////////////////汉字区域
wire		display_h_0 = ((en2 >= 'd10 + XIAYICANSHU + 'd40 && en2 <= 'd41 + XIAYICANSHU + 'd40) && (en1 >= 'd472 && en1 <= 'd535));//频
wire		display_h_1 = ((en2 >= 'd10 + XIAYICANSHU + 'd40 && en2 <= 'd41 + XIAYICANSHU + 'd40) && (en1 >= 'd536 && en1 <= 'd599));//率
wire		display_h_27 = ((en2 >= 'd10 + XIAYICANSHU - 'd40 && en2 <= 'd41 + XIAYICANSHU - 'd40) && (en1 >= 'd472 && en1 <= 'd535));//频
wire		display_h_28 = ((en2 >= 'd10 + XIAYICANSHU - 'd40 && en2 <= 'd41 + XIAYICANSHU - 'd40) && (en1 >= 'd536 && en1 <= 'd599));//率

wire		display_h_29 = ((en2 >= 'd10 + XIAYICANSHU - 'd40 && en2 <= 'd41 + XIAYICANSHU - 'd40) && (en1 >= 'd940 && en1 <= 'd1003));//峰
wire		display_h_30 = ((en2 >= 'd10 + XIAYICANSHU - 'd40 && en2 <= 'd41 + XIAYICANSHU - 'd40) && (en1 >= 'd1004 && en1 <= 'd1067));//峰
wire		display_h_31 = ((en2 >= 'd10 + XIAYICANSHU - 'd40 && en2 <= 'd41 + XIAYICANSHU - 'd40) && (en1 >= 'd1068 && en1 <= 'd1131));//值

wire		display_h_32 = ((en2 >= 'd90 + XIAYICANSHU && en2 <= 'd121 + XIAYICANSHU)&&(en1 >= 'd20 && en1 <= 'd83));//基
wire		display_h_33 = ((en2 >= 'd90 + XIAYICANSHU && en2 <= 'd121 + XIAYICANSHU) && (en1 >= 'd212 && en1 <= 'd275));//波

wire		display_h_2 = ((en2 >= 'd10 + XIAYICANSHU + 'd40 && en2 <= 'd41 + XIAYICANSHU + 'd40) && (en1 >= 'd1002 && en1 <= 'd1067));//幅
wire		display_h_3 = ((en2 >= 'd10 + XIAYICANSHU + 'd40 && en2 <= 'd41 + XIAYICANSHU + 'd40) && (en1 >= 'd1068 && en1 <= 'd1131));//值

wire 	display_h_4 = ((en2 >= 'd50 + XIAYICANSHU - 'd40 - 'd40 && en2 <= 'd81 + XIAYICANSHU - 'd40 - 'd40) && (en1 >= 'd20 && en1 <= 'd83));//正
wire		display_h_5 = ((en2 >= 'd50 + XIAYICANSHU - 'd40 - 'd40 && en2 <= 'd81 + XIAYICANSHU - 'd40 - 'd40) && (en1 >= 'd84 && en1 <= 'd147));//弦
//————————————————————————————————————————————————————————————————————
wire		display_h_6 = ((en2 >= 'd90 + XIAYICANSHU - 'd40 && en2 <= 'd121 + XIAYICANSHU - 'd40) && (en1 >= 'd20 && en1 <= 'd83));//非
wire		display_h_7 = ((en2 >= 'd90  + XIAYICANSHU - 'd40 && en2 <= 'd121 + XIAYICANSHU -  'd40) && (en1 >= 'd84 && en1 <= 'd147));//正
wire		display_h_8 = ((en2 >= 'd90  + XIAYICANSHU - 'd40 && en2 <= 'd121 + XIAYICANSHU - 'd40) && (en1 >= 'd148 && en1 <= 'd211));//弦

wire		display_h_9 = ((en2 >= 'd130  + XIAYICANSHU && en2 <= 'd161  + XIAYICANSHU) && (en1 >= 'd20 && en1 <= 'd83));//二
wire		display_h_10 = ((en2 >= 'd130  + XIAYICANSHU && en2 <= 'd161 + XIAYICANSHU) && (en1 >= 'd84 && en1 <= 'd147));//次

wire		display_h_11 = ((en2 >= 'd170 + XIAYICANSHU && en2 <= 'd201 + XIAYICANSHU) && (en1 >= 'd20 && en1 <= 'd83));//三
wire		display_h_12 = ((en2 >= 'd170 + XIAYICANSHU && en2 <= 'd201 + XIAYICANSHU) && (en1 >= 'd84 && en1 <= 'd147));//次

wire		display_h_13 = ((en2 >= 'd210 + XIAYICANSHU && en2 <= 'd241 + XIAYICANSHU) && (en1 >= 'd20 && en1 <= 'd83));//四
wire		display_h_14 = ((en2 >= 'd210 + XIAYICANSHU && en2 <= 'd241 + XIAYICANSHU) && (en1 >= 'd84 && en1 <= 'd147));//次

wire		display_h_15 = ((en2 >= 'd250 + XIAYICANSHU && en2 <= 'd281 + XIAYICANSHU) && (en1 >= 'd20 && en1 <= 'd83));//五
wire		display_h_16 = ((en2 >= 'd250 + XIAYICANSHU && en2 <= 'd281 + XIAYICANSHU) && (en1 >= 'd84 && en1 <= 'd147));//次
//————————————————————————————————————————————————————————————————————
wire		display_h_17 = ((en2 >= 'd50 + XIAYICANSHU - 'd40 - 'd40&& en2 <= 'd81 + XIAYICANSHU - 'd40 - 'd40) && (en1 >= 'd148 && en1 <= 'd211));//正弦-波
//————————————————————————————————————————————————————————————————————
wire		display_h_18 = ((en2 >= 'd90 + XIAYICANSHU - 'd40 && en2 <= 'd121 + XIAYICANSHU - 'd40) && (en1 >= 'd212 && en1 <= 'd275));//非正弦-波

wire		display_h_19 = ((en2 >= 'd130 + XIAYICANSHU && en2 <= 'd161 + XIAYICANSHU) && (en1 >= 'd148 && en1 <= 'd211));//二次-谐
wire		display_h_20 = ((en2 >= 'd130 + XIAYICANSHU && en2 <= 'd161 + XIAYICANSHU) && (en1 >= 'd212 && en1 <= 'd275));//-波

wire		display_h_21 = ((en2 >= 'd170 + XIAYICANSHU && en2 <= 'd201 + XIAYICANSHU) && (en1 >= 'd148 && en1 <= 'd211));//三次-谐
wire		display_h_22 = ((en2 >= 'd170 + XIAYICANSHU && en2 <= 'd201 + XIAYICANSHU) && (en1 >= 'd212 && en1 <= 'd275));//-波

wire		display_h_23 = ((en2 >= 'd210 + XIAYICANSHU && en2 <= 'd241 + XIAYICANSHU) && (en1 >= 'd148 && en1 <= 'd211));//四次-谐
wire		display_h_24 = ((en2 >= 'd210 + XIAYICANSHU && en2 <= 'd241 + XIAYICANSHU) && (en1 >= 'd212 && en1 <= 'd275));//-波

wire		display_h_25 = ((en2 >= 'd250 + XIAYICANSHU && en2 <= 'd281 + XIAYICANSHU) && (en1 >= 'd148 && en1 <= 'd211));//五次-谐
wire		display_h_26 = ((en2 >= 'd250 + XIAYICANSHU && en2 <= 'd281 + XIAYICANSHU) && (en1 >= 'd212 && en1 <= 'd275));//-波
//————————————————————————————————————————————————————————————————————


 wire	[33:0]	display_value_h;	
 assign display_value_h = {display_h_33,display_h_32,display_h_31,display_h_30,display_h_29,display_h_28, display_h_27,display_h_26,display_h_25,display_h_24,										display_h_23,display_h_22
									,display_h_21,display_h_20,display_h_19,display_h_18,display_h_17
									,display_h_16,display_h_15,display_h_14,display_h_13,display_h_12,display_h_11
									,display_h_10,display_h_9,display_h_8,display_h_7,display_h_6
									,display_h_5,display_h_4,display_h_3,display_h_2,display_h_1
									,display_h_0};
									
 reg  [10:0]	m_h;
 always @(posedge clk or negedge rst_n)
		if (!rst_n)
			m_h <= 11'd0;
		else 
			case (display_value_h)		
				34'b00_0000_0000_0000_0000_0000_0000_0000_0001 : m_h <= en2 - 11'd10 + 11'd0 - XIAYICANSHU - 'd40;		//频				//更改地址
				34'b00_0000_0000_0000_0000_0000_0000_0000_0010 : m_h <= en2 - 11'd10 + 11'd32- XIAYICANSHU - 'd40;	//率
				34'b00_0000_0000_0000_0000_0000_0000_0000_0100 : m_h <= en2 - 11'd10 + 11'd64- XIAYICANSHU - 'd40;	//幅
				34'b00_0000_0000_0000_0000_0000_0000_0000_1000 : m_h <= en2 - 11'd10 + 11'd96- XIAYICANSHU - 'd40;	//值
				    
				34'b00_0000_0000_0000_0000_0000_0000_0001_0000 : m_h <= en2 - 11'd50 + 11'd128- XIAYICANSHU + 'd40 + 'd40;	//正
				34'b00_0000_0000_0000_0000_0000_0000_0010_0000 : m_h <= en2 - 11'd50 + 11'd160- XIAYICANSHU + 'd40 + 'd40;	//弦
			       
				34'b00_0000_0000_0000_0000_0000_0000_0100_0000 : m_h <= en2 - 11'd90 + 11'd192- XIAYICANSHU + 'd40;	//非
				34'b00_0000_0000_0000_0000_0000_0000_1000_0000 : m_h <= en2 - 11'd90 + 11'd128- XIAYICANSHU + 'd40;	//正
				34'b00_0000_0000_0000_0000_0000_0001_0000_0000 : m_h <= en2 - 11'd90 +	11'd160- XIAYICANSHU + 'd40;	//弦
			         
				34'b00_0000_0000_0000_0000_0000_0010_0000_0000 : m_h <= en2 - 11'd130 + 11'd224- XIAYICANSHU;	//二
				34'b00_0000_0000_0000_0000_0000_0100_0000_0000 : m_h <= en2 - 11'd130 + 11'd352- XIAYICANSHU;	//次
			          
				34'b00_0000_0000_0000_0000_0000_1000_0000_0000 : m_h <= en2 - 11'd170 + 11'd256- XIAYICANSHU;	//三
				34'b00_0000_0000_0000_0000_0001_0000_0000_0000 : m_h <= en2 - 11'd170 + 11'd352- XIAYICANSHU;	//次
			    
				34'b00_0000_0000_0000_0000_0010_0000_0000_0000 : m_h <= en2 - 11'd210 + 11'd288- XIAYICANSHU;	//四
				34'b00_0000_0000_0000_0000_0100_0000_0000_0000 : m_h <= en2 - 11'd210 + 11'd352- XIAYICANSHU;	//次
			        
				34'b00_0000_0000_0000_0000_1000_0000_0000_0000 : m_h <= en2 - 11'd250 + 11'd320- XIAYICANSHU;	//五
				34'b00_0000_0000_0000_0001_0000_0000_0000_0000 : m_h <= en2 - 11'd250 + 11'd352- XIAYICANSHU;	//次
				
				34'b00_0000_0000_0000_0010_0000_0000_0000_0000 : m_h <= en2 - 11'd50 + 11'd416- XIAYICANSHU + 'd40 + 'd40;	//正弦-波
				34'b00_0000_0000_0000_0100_0000_0000_0000_0000 : m_h <= en2 - 11'd90 + 11'd416- XIAYICANSHU + 'd40;	//非正弦-波
				
				34'b00_0000_0000_0000_1000_0000_0000_0000_0000 : m_h <= en2 - 11'd130 + 11'd384- XIAYICANSHU;	//二次-谐
				34'b00_0000_0000_0001_0000_0000_0000_0000_0000 : m_h <= en2 - 11'd130 + 11'd416- XIAYICANSHU;	//二次谐-波
				
				34'b00_0000_0000_0010_0000_0000_0000_0000_0000 : m_h <= en2 - 11'd170 + 11'd384- XIAYICANSHU;	//三次-谐
				34'b00_0000_0000_0100_0000_0000_0000_0000_0000 : m_h <= en2 - 11'd170 + 11'd416- XIAYICANSHU;	//三次谐-波
				   
				34'b00_0000_0000_1000_0000_0000_0000_0000_0000 : m_h <= en2 - 11'd210 + 11'd384- XIAYICANSHU;	//四次-谐
				34'b00_0000_0001_0000_0000_0000_0000_0000_0000 : m_h <= en2 - 11'd210 + 11'd416- XIAYICANSHU;	//四次谐-波
				 
				34'b00_0000_0010_0000_0000_0000_0000_0000_0000 : m_h <= en2 - 11'd250 + 11'd384- XIAYICANSHU;	//五次-谐
				34'b00_0000_0100_0000_0000_0000_0000_0000_0000 : m_h <= en2 - 11'd250 + 11'd416- XIAYICANSHU;	//五次谐-波
				34'b00_0000_1000_0000_0000_0000_0000_0000_0000 : m_h <= en2 - 11'd10 + 11'd0 - XIAYICANSHU + 'd40;		//频				//更改地址
				34'b00_0001_0000_0000_0000_0000_0000_0000_0000 : m_h <= en2 - 11'd10 + 11'd32- XIAYICANSHU + 'd40;	//率
				34'b00_0010_0000_0000_0000_0000_0000_0000_0000 : m_h <= en2 - 11'd10 + 11'd544  - XIAYICANSHU + 'd40;	//峰
				34'b00_0100_0000_0000_0000_0000_0000_0000_0000 : m_h <= en2 - 11'd10 + 11'd544  - XIAYICANSHU + 'd40;	//峰
				34'b00_1000_0000_0000_0000_0000_0000_0000_0000 : m_h <= en2 - 11'd10 + 11'd144  +11'd32 - XIAYICANSHU - 'd40;	//值
				34'b01_0000_0000_0000_0000_0000_0000_0000_0000 : m_h <= en2 -  11'd50 - XIAYICANSHU - 11'd40 + 11'd479;	//基
				34'b10_0000_0000_0000_0000_0000_0000_0000_0000 : m_h <= en2 - 11'd50 - XIAYICANSHU -  11'd40 + 11'd509;	//波
				default : m_h <= 11'd0;
			endcase
	
				
 reg [10:0] n_h;
 always @(posedge clk or negedge rst_n)		
		if (!rst_n)
			n_h <= 11'd0;									
		else
			case (display_value_h)					
				34'b00_0000_0000_0000_0000_0000_0000_0000_0001 : n_h <= en1 - 11'd472;//频	
				34'b00_0000_0000_0000_0000_0000_0000_0000_0010 : n_h <= en1 - 11'd536;//率
				34'b00_0000_0000_0000_0000_0000_0000_0000_0100 : n_h <= en1 - 11'd1002;//幅
				34'b00_0000_0000_0000_0000_0000_0000_0000_1000 : n_h <= en1 - 11'd1068;//值
				  
				34'b00_0000_0000_0000_0000_0000_0000_0001_0000 : n_h <= en1 - 11'd20;//正				
				34'b00_0000_0000_0000_0000_0000_0000_0010_0000 : n_h <= en1 - 11'd84;//弦
				  
				34'b00_0000_0000_0000_0000_0000_0000_0100_0000 : n_h <= en1 - 11'd20;//非			
				34'b00_0000_0000_0000_0000_0000_0000_1000_0000 : n_h <= en1 - 11'd84;//正
				34'b00_0000_0000_0000_0000_0000_0001_0000_0000 : n_h <= en1 - 11'd148;//弦
				  
				34'b00_0000_0000_0000_0000_0000_0010_0000_0000 : n_h <= en1 - 11'd20;//二				
				34'b00_0000_0000_0000_0000_0000_0100_0000_0000 : n_h <= en1 - 11'd84;//次
				  
				34'b00_0000_0000_0000_0000_0000_1000_0000_0000 : n_h <= en1 - 11'd20;//三				
				34'b00_0000_0000_0000_0000_0001_0000_0000_0000 : n_h <= en1 - 11'd84;//次
				  
				34'b00_0000_0000_0000_0000_0010_0000_0000_0000 : n_h <= en1 - 11'd20;//四	
				34'b00_0000_0000_0000_0000_0100_0000_0000_0000 : n_h <= en1 - 11'd84;//次
			      
				34'b00_0000_0000_0000_0000_1000_0000_0000_0000 : n_h <= en1 - 11'd20;//五
				34'b00_0000_0000_0000_0001_0000_0000_0000_0000 : n_h <= en1 - 11'd84;//次
				  
				34'b00_0000_0000_0000_0010_0000_0000_0000_0000 : n_h <= en1 - 11'd148;	
				34'b00_0000_0000_0000_0100_0000_0000_0000_0000 : n_h <= en1 - 11'd212;
				  
				34'b00_0000_0000_0000_1000_0000_0000_0000_0000 : n_h <= en1 - 11'd148;
				34'b00_0000_0000_0001_0000_0000_0000_0000_0000 : n_h <= en1 - 11'd212;
				  
				34'b00_0000_0000_0010_0000_0000_0000_0000_0000 : n_h <= en1 - 11'd148;
				34'b00_0000_0000_0100_0000_0000_0000_0000_0000 : n_h <= en1 - 11'd212;
			      
				34'b00_0000_0000_1000_0000_0000_0000_0000_0000 : n_h <= en1 - 11'd148;
				34'b00_0000_0001_0000_0000_0000_0000_0000_0000 : n_h <= en1 - 11'd212;
				  
				34'b00_0000_0010_0000_0000_0000_0000_0000_0000 : n_h <= en1 - 11'd148;
				34'b00_0000_0100_0000_0000_0000_0000_0000_0000 : n_h <= en1 - 11'd212;
				34'b00_0000_1000_0000_0000_0000_0000_0000_0000 : n_h <= en1 - 11'd472;		//频				//更改地址
				34'b00_0001_0000_0000_0000_0000_0000_0000_0000 : n_h <= en1 - 11'd536;	//率
				  
				34'b00_0010_0000_0000_0000_0000_0000_0000_0000 : n_h <= en1 - 11'd940;	//峰
				34'b00_0100_0000_0000_0000_0000_0000_0000_0000 : n_h <= en1 - 11'd1004;	//峰
				34'b00_1000_0000_0000_0000_0000_0000_0000_0000 : n_h <= en1 - 11'd1068;	//值
				34'b01_0000_0000_0000_0000_0000_0000_0000_0000 : n_h <= en1 - 11'd20;	//基
				34'b10_0000_0000_0000_0000_0000_0000_0000_0000 : n_h <= en1 - 11'd212;	//波
				default : n_h <= 11'd0;
				endcase			
 //////////////////////////////////////////////////////////////////////////////////汉字部分结束	


 //////////////////////////////////////////////////////////////////////////单位部分开始
 wire	 	display_d_0 = ((en2 >= 'd10 + XIAYICANSHU + 'd40 && en2 <= 'd41 + XIAYICANSHU + 'd40) && (en1 >= 'd600 && en1 <= 'd663));//(
 wire		display_d_1 = ((en2 >= 'd10 + XIAYICANSHU + 'd40 && en2 <= 'd41 + XIAYICANSHU + 'd40) && (en1 >= 'd664 && en1 <= 'd727));//H
 wire		display_d_2 = ((en2 >= 'd10 + XIAYICANSHU + 'd40 && en2 <= 'd41 + XIAYICANSHU + 'd40) && (en1 >= 'd728 && en1 <= 'd791));//Z
 wire		display_d_3 = ((en2 >= 'd10 + XIAYICANSHU + 'd40 && en2 <= 'd41 + XIAYICANSHU + 'd40) && (en1 >= 'd792 && en1 <= 'd855));//)
                                                                                     
 wire		display_d_4 = ((en2 >= 'd10 + XIAYICANSHU + 'd40 && en2 <= 'd41 + XIAYICANSHU + 'd40) && (en1 >= 'd1132 && en1 <= 'd1195));//(
 wire		display_d_5 = ((en2 >= 'd10 + XIAYICANSHU + 'd40 && en2 <= 'd41 + XIAYICANSHU + 'd40) && (en1 >= 'd1196 && en1 <= 'd1259));//m
 wire		display_d_6 = ((en2 >= 'd10  + XIAYICANSHU+ 'd40  && en2 <= 'd41 + XIAYICANSHU + 'd40) && (en1 >= 'd1260 && en1 <= 'd1323));//A
 wire		display_d_7 = ((en2 >= 'd10 + XIAYICANSHU + 'd40 && en2 <= 'd41 + XIAYICANSHU + 'd40) && (en1 >= 'd1324 && en1 <= 'd1387));//)
 
 wire	 	display_d_8 = ((en2 >= 'd10 + XIAYICANSHU - 'd40 && en2 <= 'd41 + XIAYICANSHU - 'd40) && (en1 >= 'd600 && en1 <= 'd663));//(
 wire		display_d_9 = ((en2 >= 'd10 + XIAYICANSHU - 'd40 && en2 <= 'd41 + XIAYICANSHU - 'd40) && (en1 >= 'd664 && en1 <= 'd727));//H
 wire		display_d_10 = ((en2 >= 'd10 + XIAYICANSHU - 'd40 && en2 <= 'd41 + XIAYICANSHU - 'd40) && (en1 >= 'd728 && en1 <= 'd791));//Z
 wire		display_d_11 = ((en2 >= 'd10 + XIAYICANSHU - 'd40 && en2 <= 'd41 + XIAYICANSHU - 'd40) && (en1 >= 'd792 && en1 <= 'd855));//)
                                                                                     
 wire		display_d_12 = ((en2 >= 'd10 + XIAYICANSHU - 'd40 && en2 <= 'd41 + XIAYICANSHU - 'd40) && (en1 >= 'd1132 && en1 <= 'd1195));//(
 wire		display_d_13 = ((en2 >= 'd10 + XIAYICANSHU - 'd40 && en2 <= 'd41 + XIAYICANSHU - 'd40) && (en1 >= 'd1196 && en1 <= 'd1259));//m
 wire		display_d_14 = ((en2 >= 'd10  + XIAYICANSHU - 'd40  && en2 <= 'd41 + XIAYICANSHU - 'd40) && (en1 >= 'd1260 && en1 <= 'd1323));//A
 wire		display_d_15 = ((en2 >= 'd10 + XIAYICANSHU - 'd40 && en2 <= 'd41 + XIAYICANSHU - 'd40) && (en1 >= 'd1324 && en1 <= 'd1387));//)
 
 wire	[15:0]	display_value_d;
 assign display_value_d = {display_d_15,display_d_14,display_d_13,display_d_12,display_d_11,display_d_10,
											display_d_9,display_d_8,display_d_7,display_d_6,display_d_5,display_d_4,
											display_d_3,display_d_2,display_d_1,display_d_0};

 
 reg  [10:0]	m_d;
 always @(posedge clk or negedge rst_n)
		if (!rst_n)
			m_d <= 11'd0;
		else
			case	(display_value_d) 
				16'b0000_0000_0000_0001 : m_d <= en2- 11'd10+ 11'd0- XIAYICANSHU - 'd40;		//(
				16'b0000_0000_0000_0010 : m_d <= en2- 11'd10+ 11'd32- XIAYICANSHU - 'd40;	//H 
				16'b0000_0000_0000_0100 : m_d <= en2- 11'd10+ 11'd64- XIAYICANSHU - 'd40;	//Z
				16'b0000_0000_0000_1000 : m_d <= en2- 11'd10+ 11'd96- XIAYICANSHU - 'd40;	//)
                         
				16'b0000_0000_0001_0000 : m_d <= en2- 11'd10+ 11'd128- XIAYICANSHU - 'd40;	//(
				16'b0000_0000_0010_0000 : m_d <= en2- 11'd10+ 11'd160- XIAYICANSHU - 'd40;	//m
				16'b0000_0000_0100_0000 : m_d <= en2- 11'd10+ 11'd192- XIAYICANSHU - 'd40;	//A
				16'b0000_0000_1000_0000 : m_d <= en2- 11'd10+ 11'd224- XIAYICANSHU - 'd40;	//)
			             
				16'b0000_0001_0000_0000 : m_d <= en2- 11'd10+ 11'd0- XIAYICANSHU + 'd40;		//(
				16'b0000_0010_0000_0000 : m_d <= en2- 11'd10+ 11'd32- XIAYICANSHU + 'd40;	//H 
				16'b0000_0100_0000_0000 : m_d <= en2- 11'd10+ 11'd64- XIAYICANSHU + 'd40;	//Z
				16'b0000_1000_0000_0000 : m_d <= en2- 11'd10+ 11'd96- XIAYICANSHU + 'd40;	//)
                              
				16'b0001_0000_0000_0000 : m_d <= en2- 11'd10+ 11'd128- XIAYICANSHU + 'd40;	//(
				16'b0010_0000_0000_0000 : m_d <= en2- 11'd10+ 11'd160- XIAYICANSHU + 'd40;	//m
				16'b0100_0000_0000_0000 : m_d <= en2- 11'd10+ 11'd192- XIAYICANSHU + 'd40;	//A
				16'b1000_0000_0000_0000 : m_d <= en2- 11'd10+ 11'd224- XIAYICANSHU + 'd40;	//)
				default : m_d <= 11'd0;
			endcase			
			
	 reg  [10:0]	n_d;
 always @(posedge clk or negedge rst_n)
		if (!rst_n)
			n_d <=11'd0;
		else
			case	(display_value_d)
				16'b0000_0000_0000_0001 : n_d <= en1 - 11'd600;	//(
				16'b0000_0000_0000_0010 : n_d <= en1 - 11'd664;	//H
				16'b0000_0000_0000_0100 : n_d <= en1 - 11'd728;	//Z
				16'b0000_0000_0000_1000 : n_d <= en1 - 11'd792;	//)
				                         
				16'b0000_0000_0001_0000 : n_d <= en1 - 11'd1132;	//(
				16'b0000_0000_0010_0000 : n_d <= en1 - 11'd1196;	//m
				16'b0000_0000_0100_0000 : n_d <= en1 - 11'd1260;	//A
				16'b0000_0000_1000_0000 : n_d <= en1 - 11'd1324;	//)
			
				16'b0000_0001_0000_0000 : n_d <= en1 - 11'd600;	//(
				16'b0000_0010_0000_0000 : n_d <= en1 - 11'd664;	//H
				16'b0000_0100_0000_0000 : n_d <= en1 - 11'd728;	//Z
				16'b0000_1000_0000_0000 : n_d <= en1 - 11'd792;	//)
				                      
				16'b0001_0000_0000_0000 : n_d <= en1 - 11'd1132;	//(
				16'b0010_0000_0000_0000 : n_d <= en1 - 11'd1196;	//m
				16'b0100_0000_0000_0000 : n_d <= en1 - 11'd1260;	//A
				16'b1000_0000_0000_0000 : n_d <= en1 - 11'd1324;	//)
				default : n_d <=11'd0;
			endcase
 ///////////////////////////////////////////////////////////单位部分结束
// 
//
//
// //////////////////////////////////////////////////////////////////////////数字部分开始

   wire		[3:0]		Q0_0;				//正弦波频率低位到高位
	wire		[3:0]		Q0_1;
	wire		[3:0]		Q0_2;
	wire		[3:0]		Q0_3;
	wire		[3:0]		Q0_4;

 assign				Q0_0 = zx_P/1%10;
 assign				Q0_1 = zx_P/10%10;
 assign				Q0_2 = zx_P/100%10;
 assign				Q0_3 = zx_P/1000%10;
 assign				Q0_4 = zx_P/10000%10;
 
   wire		[3:0]		Q1_0;				//正弦波幅值低位到高位
	wire		[3:0]		Q1_1;
	wire		[3:0]		Q1_2;
	wire		[3:0]		Q1_3;
	wire		[3:0]		Q1_4;
	
 assign				Q1_0 = zx_F/1%10;
 assign				Q1_1 = zx_F/10%10;
 assign				Q1_2 = zx_F/100%10;
 assign				Q1_3 = zx_F/1000%10;
 assign				Q1_4 = zx_F/10000%10;
//////////////////////////////////////////////////////////
   wire		[3:0]		Q2_0;				//非正弦波频率低位到高位
	wire		[3:0]		Q2_1;
	wire		[3:0]		Q2_2;
	wire		[3:0]		Q2_3;
	wire		[3:0]		Q2_4;

 assign				Q2_0 = fzx_P/1%10;
 assign				Q2_1 = fzx_P/10%10;
 assign				Q2_2 = fzx_P/100%10;
 assign				Q2_3 = fzx_P/1000%10;
 assign				Q2_4 = fzx_P/10000%10;
 
   wire		[3:0]		Q3_0;				//非正弦波幅值低位到高位
	wire		[3:0]		Q3_1;
	wire		[3:0]		Q3_2;
	wire		[3:0]		Q3_3;
	wire		[3:0]		Q3_4;

 assign				Q3_0 = fzx_F/1%10;
 assign				Q3_1 = fzx_F/10%10;
 assign				Q3_2 = fzx_F/100%10;
 assign				Q3_3 = fzx_F/1000%10;
 assign				Q3_4 = fzx_F/10000%10;
/////////////////////////////////////////////////////////// 
   wire		[3:0]		Q4_0;				//二次谐波频率低位到高位
	wire		[3:0]		Q4_1;
	wire		[3:0]		Q4_2;
	wire		[3:0]		Q4_3;
	wire		[3:0]		Q4_4;

 assign				Q4_0 = fzx_2_P/1%10;
 assign				Q4_1 = fzx_2_P/10%10;
 assign				Q4_2 = fzx_2_P/100%10;
 assign				Q4_3 = fzx_2_P/1000%10;
 assign				Q4_4 = fzx_2_P/10000%10;
 ///////////////////////////////////////////////////////
   wire		[3:0]		Q5_0;				//二次谐波幅值低位到高位
	wire		[3:0]		Q5_1;
	wire		[3:0]		Q5_2;
	wire		[3:0]		Q5_3;
	wire		[3:0]		Q5_4;

 assign				Q5_0 = fzx_2_F/1%10;
 assign				Q5_1 = fzx_2_F/10%10;
 assign				Q5_2 = fzx_2_F/100%10;
 assign				Q5_3 = fzx_2_F/1000%10;
 assign				Q5_4 = fzx_2_F/10000%10;
////////////////////////////////////////////////////
   wire		[3:0]		Q6_0;				//三次谐波频率低位到高位
	wire		[3:0]		Q6_1;
	wire		[3:0]		Q6_2;
	wire		[3:0]		Q6_3;
	wire		[3:0]		Q6_4;

 assign				Q6_0 = fzx_3_P/1%10;
 assign				Q6_1 = fzx_3_P/10%10;
 assign				Q6_2 = fzx_3_P/100%10;
 assign				Q6_3 = fzx_3_P/1000%10;
 assign				Q6_4 = fzx_3_P/10000%10;
 
   wire		[3:0]		Q7_0;				//三次谐波幅值低位到高位
	wire		[3:0]		Q7_1;
	wire		[3:0]		Q7_2;
	wire		[3:0]		Q7_3;
	wire		[3:0]		Q7_4;

 assign				Q7_0 = fzx_3_F/1%10;
 assign				Q7_1 = fzx_3_F/10%10;
 assign				Q7_2 = fzx_3_F/100%10;
 assign				Q7_3 = fzx_3_F/1000%10;
 assign				Q7_4 = fzx_3_F/10000%10;
 ////////////////////////////////////////////////////////
   wire		[3:0]		Q8_0;				//四次谐波频率低位到高位
	wire		[3:0]		Q8_1;
	wire		[3:0]		Q8_2;
	wire		[3:0]		Q8_3;
	wire		[3:0]		Q8_4;

 assign				Q8_0 = fzx_4_P/1%10;
 assign				Q8_1 = fzx_4_P/10%10;
 assign				Q8_2 = fzx_4_P/100%10;
 assign				Q8_3 = fzx_4_P/1000%10;
 assign				Q8_4 = fzx_4_P/10000%10;
 
   wire		[3:0]		Q9_0;				//四次谐波幅值低位到高位
	wire		[3:0]		Q9_1;
	wire		[3:0]		Q9_2;
	wire		[3:0]		Q9_3;
	wire		[3:0]		Q9_4;

 assign				Q9_0 = fzx_4_F/1%10;
 assign				Q9_1 = fzx_4_F/10%10;
 assign				Q9_2 = fzx_4_F/100%10;
 assign				Q9_3 = fzx_4_F/1000%10;
 assign				Q9_4 = fzx_4_F/10000%10;
 ////////////////////////////////////////////////////
   wire		[3:0]		Q10_0;				//五次谐波频率低位到高位
	wire		[3:0]		Q10_1;
	wire		[3:0]		Q10_2;
	wire		[3:0]		Q10_3;
	wire		[3:0]		Q10_4;

 assign				Q10_0 = fzx_5_P/1%10;
 assign				Q10_1 = fzx_5_P/10%10;
 assign				Q10_2 = fzx_5_P/100%10;
 assign				Q10_3 = fzx_5_P/1000%10;
 assign				Q10_4 = fzx_5_P/10000%10;
 
   wire		[3:0]		Q11_0;				//五次谐波幅值低位到高位
	wire		[3:0]		Q11_1;
	wire		[3:0]		Q11_2;
	wire		[3:0]		Q11_3;
	wire		[3:0]		Q11_4;

 assign				Q11_0 = fzx_5_F/1%10;
 assign				Q11_1 = fzx_5_F/10%10;
 assign				Q11_2 = fzx_5_F/100%10;
 assign				Q11_3 = fzx_5_F/1000%10;
 assign				Q11_4 = fzx_5_F/10000%10; 
//////////////////////////////////////////////////////////////////
 
 
 
 wire			display_s0_0 = ((en2 >= 'd50 + XIAYICANSHU- 'd40 && en2 <= 'd81 + XIAYICANSHU  - 'd40) && (en1 >= 'd472 && en1 <= 'd535));//正弦波频率
 wire			display_s0_1 = ((en2 >= 'd50 + XIAYICANSHU - 'd40 && en2 <= 'd81 + XIAYICANSHU - 'd40) && (en1 >= 'd536 && en1 <= 'd599));
 wire			display_s0_2 = ((en2 >= 'd50 + XIAYICANSHU - 'd40 && en2 <= 'd81 + XIAYICANSHU - 'd40) && (en1 >= 'd600 && en1 <= 'd663));
 wire			display_s0_3 = ((en2 >= 'd50 + XIAYICANSHU - 'd40 && en2 <= 'd81 + XIAYICANSHU - 'd40) && (en1 >= 'd664 && en1 <= 'd727));
 wire			display_s0_4 = ((en2 >= 'd50 + XIAYICANSHU - 'd40 && en2 <= 'd81 + XIAYICANSHU - 'd40) && (en1 >= 'd728 && en1 <= 'd791));//点
 wire			display_s0_5 = ((en2 >= 'd50 + XIAYICANSHU - 'd40 && en2 <= 'd81 + XIAYICANSHU - 'd40) && (en1 >= 'd792 && en1 <= 'd855));
                                                                                                                                            
 wire			display_s0_6 = ((en2 >= 'd50 + XIAYICANSHU - 'd40 && en2 <= 'd81 + XIAYICANSHU - 'd40) && (en1 >= 'd1002 && en1 <= 'd1067));//正弦波幅值
 wire			display_s0_7 = ((en2 >= 'd50 + XIAYICANSHU - 'd40 && en2 <= 'd81 + XIAYICANSHU - 'd40) && (en1 >= 'd1068 && en1 <= 'd1131));
 wire			display_s0_8 = ((en2 >= 'd50 + XIAYICANSHU - 'd40 && en2 <= 'd81 + XIAYICANSHU - 'd40) && (en1 >= 'd1132 && en1 <= 'd1195));
 wire			display_s0_9 = ((en2 >= 'd50 + XIAYICANSHU - 'd40 && en2 <= 'd81 + XIAYICANSHU - 'd40) && (en1 >= 'd1196 && en1 <= 'd1259));
 wire			display_s0_10 = ((en2 >= 'd50 + XIAYICANSHU - 'd40 && en2 <= 'd81 + XIAYICANSHU - 'd40) && (en1 >= 'd1260 && en1 <= 'd1323));//点
 wire			display_s0_11 = ((en2 >= 'd50 + XIAYICANSHU - 'd40 && en2 <= 'd81 + XIAYICANSHU - 'd40) && (en1 >= 'd1324 && en1 <= 'd1387));
 
 
 
 wire			display_s1_0 = ((en2 >= 'd90 + XIAYICANSHU && en2 <= 'd121 + XIAYICANSHU) && (en1 >= 'd472 && en1 <= 'd535));//非正弦波频率
 wire			display_s1_1 = ((en2 >= 'd90 + XIAYICANSHU && en2 <= 'd121 + XIAYICANSHU) && (en1 >= 'd536 && en1 <= 'd599));
 wire			display_s1_2 = ((en2 >= 'd90 + XIAYICANSHU && en2 <= 'd121 + XIAYICANSHU) && (en1 >= 'd600 && en1 <= 'd663));
 wire			display_s1_3 = ((en2 >= 'd90 + XIAYICANSHU && en2 <= 'd121 + XIAYICANSHU) && (en1 >= 'd664 && en1 <= 'd727));
 wire			display_s1_4 = ((en2 >= 'd90 + XIAYICANSHU && en2 <= 'd121 + XIAYICANSHU) && (en1 >= 'd728 && en1 <= 'd791));//点
 wire			display_s1_5 = ((en2 >= 'd90 + XIAYICANSHU && en2 <= 'd121 + XIAYICANSHU) && (en1 >= 'd792 && en1 <= 'd855));	
 
 wire			display_s1_6 = ((en2 >= 'd90 + XIAYICANSHU && en2 <= 'd121 + XIAYICANSHU) && (en1 >= 'd1002 && en1 <= 'd1067));//非正弦波幅值
 wire			display_s1_7 = ((en2 >= 'd90 + XIAYICANSHU && en2 <= 'd121 + XIAYICANSHU) && (en1 >= 'd1068 && en1 <= 'd1131));
 wire			display_s1_8 = ((en2 >= 'd90 + XIAYICANSHU && en2 <= 'd121 + XIAYICANSHU) && (en1 >= 'd1132 && en1 <= 'd1195));
 wire			display_s1_9 = ((en2 >= 'd90 + XIAYICANSHU && en2 <= 'd121 + XIAYICANSHU) && (en1 >= 'd1196 && en1 <= 'd1259));
 wire			display_s1_10 = ((en2 >= 'd90 + XIAYICANSHU && en2 <= 'd121 + XIAYICANSHU) && (en1 >= 'd1260 && en1 <= 'd1323));//点
 wire			display_s1_11 = ((en2 >= 'd90 + XIAYICANSHU && en2 <= 'd121 + XIAYICANSHU) && (en1 >= 'd1324 && en1 <= 'd1387));
 
 
 
 wire			display_s2_0 = ((en2 >= 'd130 + XIAYICANSHU && en2 <= 'd161 + XIAYICANSHU) && (en1 >= 'd472 && en1 <= 'd535));//二次谐波频率
 wire			display_s2_1 = ((en2 >= 'd130 + XIAYICANSHU && en2 <= 'd161 + XIAYICANSHU) && (en1 >= 'd536 && en1 <= 'd599));
 wire			display_s2_2 = ((en2 >= 'd130 + XIAYICANSHU && en2 <= 'd161 + XIAYICANSHU) && (en1 >= 'd600 && en1 <= 'd663));
 wire			display_s2_3 = ((en2 >= 'd130 + XIAYICANSHU && en2 <= 'd161 + XIAYICANSHU) && (en1 >= 'd664 && en1 <= 'd727));
 wire			display_s2_4 = ((en2 >= 'd130 + XIAYICANSHU && en2 <= 'd161 + XIAYICANSHU) && (en1 >= 'd728 && en1 <= 'd791));//点
 wire			display_s2_5 = ((en2 >= 'd130 + XIAYICANSHU && en2 <= 'd161 + XIAYICANSHU) && (en1 >= 'd792 && en1 <= 'd855));	
 
 wire			display_s2_6 = ((en2 >= 'd130 + XIAYICANSHU && en2 <= 'd161 + XIAYICANSHU) && (en1 >= 'd1002 && en1 <= 'd1067));//二次谐波幅值
 wire			display_s2_7 = ((en2 >= 'd130 + XIAYICANSHU && en2 <= 'd161 + XIAYICANSHU) && (en1 >= 'd1068 && en1 <= 'd1131));
 wire			display_s2_8 = ((en2 >= 'd130 + XIAYICANSHU && en2 <= 'd161 + XIAYICANSHU) && (en1 >= 'd1132 && en1 <= 'd1195));
 wire			display_s2_9 = ((en2 >= 'd130 + XIAYICANSHU && en2 <= 'd161 + XIAYICANSHU) && (en1 >= 'd1196 && en1 <= 'd1259));
 wire			display_s2_10 = ((en2 >= 'd130 + XIAYICANSHU && en2 <= 'd161 + XIAYICANSHU) && (en1 >= 'd1260 && en1 <= 'd1323));//点
 wire			display_s2_11 = ((en2 >= 'd130 + XIAYICANSHU && en2 <= 'd161 + XIAYICANSHU) && (en1 >= 'd1324 && en1 <= 'd1387));
 
 
 
 wire			display_s3_0 = ((en2 >= 'd170 + XIAYICANSHU && en2 <= 'd201 + XIAYICANSHU) && (en1 >= 'd472 && en1 <= 'd535));//三次谐波频率
 wire			display_s3_1 = ((en2 >= 'd170  + XIAYICANSHU && en2 <= 'd201 + XIAYICANSHU) && (en1 >= 'd536 && en1 <= 'd599));
 wire			display_s3_2 = ((en2 >= 'd170 + XIAYICANSHU && en2 <= 'd201 + XIAYICANSHU) && (en1 >= 'd600 && en1 <= 'd663));
 wire			display_s3_3 = ((en2 >= 'd170 + XIAYICANSHU && en2 <= 'd201 + XIAYICANSHU) && (en1 >= 'd664 && en1 <= 'd727));
 wire			display_s3_4 = ((en2 >= 'd170 + XIAYICANSHU && en2 <= 'd201 + XIAYICANSHU) && (en1 >= 'd728 && en1 <= 'd791));//点
 wire			display_s3_5 = ((en2 >= 'd170 + XIAYICANSHU && en2 <= 'd201 + XIAYICANSHU) && (en1 >= 'd792 && en1 <= 'd855));	
 
 wire			display_s3_6 = ((en2 >= 'd170 + XIAYICANSHU && en2 <= 'd201 + XIAYICANSHU) && (en1 >= 'd1002 && en1 <= 'd1067));//三次谐波幅值
 wire			display_s3_7 = ((en2 >= 'd170 + XIAYICANSHU && en2 <= 'd201 + XIAYICANSHU) && (en1 >= 'd1068 && en1 <= 'd1131));
 wire			display_s3_8 = ((en2 >= 'd170 + XIAYICANSHU && en2 <= 'd201 + XIAYICANSHU) && (en1 >= 'd1132 && en1 <= 'd1195));
 wire			display_s3_9 = ((en2 >= 'd170 + XIAYICANSHU && en2 <= 'd201 + XIAYICANSHU) && (en1 >= 'd1196 && en1 <= 'd1259));
 wire			display_s3_10 = ((en2 >= 'd170 + XIAYICANSHU && en2 <= 'd201 + XIAYICANSHU) && (en1 >= 'd1260 && en1 <= 'd1323));//点
 wire			display_s3_11 = ((en2 >= 'd170 + XIAYICANSHU && en2 <= 'd201 + XIAYICANSHU) && (en1 >= 'd1324 && en1 <= 'd1387));
 
 
 
 wire			display_s4_0 = ((en2 >= 'd210 + XIAYICANSHU && en2 <= 'd241 + XIAYICANSHU) && (en1 >= 'd472 && en1 <= 'd535));//四次谐波频率
 wire			display_s4_1 = ((en2 >= 'd210 + XIAYICANSHU && en2 <= 'd241 + XIAYICANSHU) && (en1 >= 'd536 && en1 <= 'd599));
 wire			display_s4_2 = ((en2 >= 'd210 + XIAYICANSHU && en2 <= 'd241 + XIAYICANSHU) && (en1 >= 'd600 && en1 <= 'd663));
 wire			display_s4_3 = ((en2 >= 'd210 + XIAYICANSHU && en2 <= 'd241 + XIAYICANSHU) && (en1 >= 'd664 && en1 <= 'd727));
 wire			display_s4_4 = ((en2 >= 'd210 + XIAYICANSHU && en2 <= 'd241 + XIAYICANSHU) && (en1 >= 'd728 && en1 <= 'd791));//点
 wire			display_s4_5 = ((en2 >= 'd210 + XIAYICANSHU && en2 <= 'd241 + XIAYICANSHU) && (en1 >= 'd792 && en1 <= 'd855));	
 
 wire			display_s4_6 = ((en2 >= 'd210 + XIAYICANSHU && en2 <= 'd241 + XIAYICANSHU) && (en1 >= 'd1002 && en1 <= 'd1067));//四次谐波幅值
 wire			display_s4_7 = ((en2 >= 'd210 + XIAYICANSHU && en2 <= 'd241 + XIAYICANSHU) && (en1 >= 'd1068 && en1 <= 'd1131));
 wire			display_s4_8 = ((en2 >= 'd210 + XIAYICANSHU && en2 <= 'd241 + XIAYICANSHU) && (en1 >= 'd1132 && en1 <= 'd1195));
 wire			display_s4_9 = ((en2 >= 'd210 + XIAYICANSHU && en2 <= 'd241 + XIAYICANSHU) && (en1 >= 'd1196 && en1 <= 'd1259));
 wire			display_s4_10 = ((en2 >= 'd210 + XIAYICANSHU && en2 <= 'd241 + XIAYICANSHU) && (en1 >= 'd1260 && en1 <= 'd1323));//点
 wire			display_s4_11 = ((en2 >= 'd210 + XIAYICANSHU && en2 <= 'd241 + XIAYICANSHU) && (en1 >= 'd1324 && en1 <= 'd1387));
 
 
 
 wire			display_s5_0 = ((en2 >= 'd250 + XIAYICANSHU && en2 <= 'd281 + XIAYICANSHU) && (en1 >= 'd472 && en1 <= 'd535));//五次谐波频率
 wire			display_s5_1 = ((en2 >= 'd250 + XIAYICANSHU && en2 <= 'd281 + XIAYICANSHU) && (en1 >= 'd536 && en1 <= 'd599));
 wire			display_s5_2 = ((en2 >= 'd250 + XIAYICANSHU && en2 <= 'd281 + XIAYICANSHU) && (en1 >= 'd600 && en1 <= 'd663));
 wire			display_s5_3 = ((en2 >= 'd250 + XIAYICANSHU && en2 <= 'd281 + XIAYICANSHU) && (en1 >= 'd664 && en1 <= 'd727));
 wire			display_s5_4 = ((en2 >= 'd250 + XIAYICANSHU && en2 <= 'd281 + XIAYICANSHU) && (en1 >= 'd728 && en1 <= 'd791));//点
 wire			display_s5_5 = ((en2 >= 'd250 + XIAYICANSHU && en2 <= 'd281 + XIAYICANSHU) && (en1 >= 'd792 && en1 <= 'd855));	
 
 wire			display_s5_6 = ((en2 >= 'd250 + XIAYICANSHU && en2 <= 'd281 + XIAYICANSHU) && (en1 >= 'd1002 && en1 <= 'd1067));//五次谐波幅值
 wire			display_s5_7 = ((en2 >= 'd250 + XIAYICANSHU && en2 <= 'd281 + XIAYICANSHU) && (en1 >= 'd1068 && en1 <= 'd1131));
 wire			display_s5_8 = ((en2 >= 'd250 + XIAYICANSHU && en2 <= 'd281 + XIAYICANSHU) && (en1 >= 'd1132 && en1 <= 'd1195));
 wire			display_s5_9 = ((en2 >= 'd250 + XIAYICANSHU && en2 <= 'd281 + XIAYICANSHU) && (en1 >= 'd1196 && en1 <= 'd1259));
 wire			display_s5_10 = ((en2 >= 'd250 + XIAYICANSHU && en2 <= 'd281 + XIAYICANSHU) && (en1 >= 'd1260 && en1 <= 'd1323));//点
 wire			display_s5_11 = ((en2 >= 'd250 + XIAYICANSHU && en2 <= 'd281 + XIAYICANSHU) && (en1 >= 'd1324 && en1 <= 'd1387));
 
 
  
  
  reg   [6:0]		display_value_s;
  always @(posedge clk or negedge rst_n)
	begin
		if (!rst_n)
			display_value_s <= 7'd0;
		else if (display_s0_0 ) display_value_s <= 7'd0 + 7'd1;
		else if (display_s0_1 ) display_value_s <= 7'd1 + 7'd1;
		else if (display_s0_2 ) display_value_s <= 7'd2 + 7'd1;
		else if (display_s0_3 ) display_value_s <= 7'd3 + 7'd1;
		else if (display_s0_4 ) display_value_s <= 7'd4 + 7'd1;
		else if (display_s0_5 ) display_value_s <= 7'd5 + 7'd1;
		else if (display_s0_6 ) display_value_s <= 7'd6 + 7'd1;
		else if (display_s0_7 ) display_value_s <= 7'd7 + 7'd1;
		else if (display_s0_8 ) display_value_s <= 7'd8 + 7'd1;
		else if (display_s0_9 ) display_value_s <= 7'd9 + 7'd1;
		else if (display_s0_10) display_value_s <= 7'd10 + 7'd1;
		else if (display_s0_11) display_value_s <= 7'd11 + 7'd1;

		else if (display_s1_0 ) display_value_s <= 7'd12 + 7'd1;
		else if (display_s1_1 ) display_value_s <= 7'd13 + 7'd1;
		else if (display_s1_2 ) display_value_s <= 7'd14 + 7'd1;
		else if (display_s1_3 ) display_value_s <= 7'd15 + 7'd1;
		else if (display_s1_4 ) display_value_s <= 7'd16 + 7'd1;
		else if (display_s1_5 ) display_value_s <= 7'd17 + 7'd1;
		else if (display_s1_6 ) display_value_s <= 7'd18 + 7'd1;
		else if (display_s1_7 ) display_value_s <= 7'd19 + 7'd1;
		else if (display_s1_8 ) display_value_s <= 7'd20 + 7'd1;
		else if (display_s1_9 ) display_value_s <= 7'd21 + 7'd1;
		else if (display_s1_10) display_value_s <= 7'd22 + 7'd1;
		else if (display_s1_11) display_value_s <= 7'd23 + 7'd1;

		else if (display_s2_0 ) display_value_s <= 7'd24 + 7'd1;
		else if (display_s2_1 ) display_value_s <= 7'd25 + 7'd1;
		else if (display_s2_2 ) display_value_s <= 7'd26 + 7'd1;
		else if (display_s2_3 ) display_value_s <= 7'd27 + 7'd1;
		else if (display_s2_4 ) display_value_s <= 7'd28 + 7'd1;
		else if (display_s2_5 ) display_value_s <= 7'd29 + 7'd1;
		else if (display_s2_6 ) display_value_s <= 7'd30 + 7'd1;
		else if (display_s2_7 ) display_value_s <= 7'd31 + 7'd1;
		else if (display_s2_8 ) display_value_s <= 7'd32 + 7'd1;
		else if (display_s2_9 ) display_value_s <= 7'd33 + 7'd1;
		else if (display_s2_10) display_value_s <= 7'd34 + 7'd1;
		else if (display_s2_11) display_value_s <= 7'd35 + 7'd1;

		else if (display_s3_0 ) display_value_s <= 7'd36 + 7'd1;
		else if (display_s3_1 ) display_value_s <= 7'd37 + 7'd1;
		else if (display_s3_2 ) display_value_s <= 7'd38 + 7'd1;
		else if (display_s3_3 ) display_value_s <= 7'd39 + 7'd1;
		else if (display_s3_4 ) display_value_s <= 7'd40 + 7'd1;
		else if (display_s3_5 ) display_value_s <= 7'd41 + 7'd1;
		else if (display_s3_6 ) display_value_s <= 7'd42 + 7'd1;
		else if (display_s3_7 ) display_value_s <= 7'd43 + 7'd1;
		else if (display_s3_8 ) display_value_s <= 7'd44 + 7'd1;
		else if (display_s3_9 ) display_value_s <= 7'd45 + 7'd1;
		else if (display_s3_10) display_value_s <= 7'd46 + 7'd1;
		else if (display_s3_11) display_value_s <= 7'd47 + 7'd1;
		
		else if (display_s4_0 ) display_value_s <= 7'd48 + 7'd1;
		else if (display_s4_1 ) display_value_s <= 7'd49 + 7'd1;
		else if (display_s4_2 ) display_value_s <= 7'd50 + 7'd1;
		else if (display_s4_3 ) display_value_s <= 7'd51 + 7'd1;
		else if (display_s4_4 ) display_value_s <= 7'd52 + 7'd1;
		else if (display_s4_5 ) display_value_s <= 7'd53 + 7'd1;
		else if (display_s4_6 ) display_value_s <= 7'd54 + 7'd1;
		else if (display_s4_7 ) display_value_s <= 7'd55 + 7'd1;
		else if (display_s4_8 ) display_value_s <= 7'd56 + 7'd1;
		else if (display_s4_9 ) display_value_s <= 7'd57 + 7'd1;
		else if (display_s4_10) display_value_s <= 7'd58 + 7'd1;
		else if (display_s4_11) display_value_s <= 7'd59 + 7'd1;

		else if (display_s5_0 )   display_value_s <= 7'd60 + 7'd1;
		else if (display_s5_1 )   display_value_s <= 7'd61 + 7'd1;
		else if (display_s5_2 )   display_value_s <= 7'd62 + 7'd1;
		else if (display_s5_3 )   display_value_s <= 7'd63 + 7'd1;
		else if (display_s5_4 )   display_value_s <= 7'd64 + 7'd1;
		else if (display_s5_5 )   display_value_s <= 7'd65 + 7'd1;
		else if (display_s5_6 )   display_value_s <= 7'd66 + 7'd1;
		else if (display_s5_7 )   display_value_s <= 7'd67 + 7'd1;
		else if (display_s5_8 )   display_value_s <= 7'd68 + 7'd1;
		else if (display_s5_9 )   display_value_s <= 7'd69 + 7'd1;
		else if (display_s5_10)   display_value_s <= 7'd70 + 7'd1;
		else if (display_s5_11)   display_value_s <= 7'd71 + 7'd1;
		else 
			display_value_s <= 7'd0;
	end
		
		
	
				
 reg	[10:0]		m_s;											//取地址
 always @(posedge clk or negedge rst_n)
	if (!rst_n)
		m_s <= 11'd0;	
	else
			case (display_value_s)
						//////////////////////////////////////////////////////正弦波频率和幅值	
						7'd1 :
									m_s <= en2 - 11'd50 + (11'd32 * Q0_4) - XIAYICANSHU + 'd40;
						7'd2 :
									m_s <= en2 - 11'd50 + (11'd32 * Q0_3)- XIAYICANSHU + 'd40;
						7'd3 :
									m_s <= en2 - 11'd50 + (11'd32 * Q0_2)- XIAYICANSHU + 'd40;
						7'd4 :
									m_s <= en2 - 11'd50 + (11'd32 * Q0_1)- XIAYICANSHU + 'd40;
						7'd5 :
									m_s <= en2 - 11'd50 + 11'd320- XIAYICANSHU + 'd40;	
						7'd6 :
									m_s <= en2 - 11'd50 + (11'd32 * Q0_0)- XIAYICANSHU + 'd40;
									
						7'd7 :
									m_s <= en2 - 11'd50 + (11'd32 * Q1_4)- XIAYICANSHU + 'd40;					
						7'd8 :
									m_s <= en2 - 11'd50 + (11'd32 * Q1_3)- XIAYICANSHU + 'd40;
						7'd9 :
									m_s <= en2 - 11'd50 + (11'd32 * Q1_2)- XIAYICANSHU + 'd40;
						7'd10 :
									m_s <= en2 - 11'd50 + (11'd32 * Q1_1)- XIAYICANSHU + 'd40;
						7'd11 :
									m_s <= en2 - 11'd50 + 11'd320- XIAYICANSHU + 'd40;
						7'd12 :
									m_s <= en2 - 11'd50 + (11'd32 * Q1_0)- XIAYICANSHU + 'd40;
									
						/////////////////////////////////////////////////////////非正弦波频率和幅值					
						7'd13 :
									m_s <= en2 - 11'd90 + (11'd32 * Q2_4)- XIAYICANSHU;
						7'd14 :
									m_s <= en2 - 11'd90 + (11'd32 * Q2_3)- XIAYICANSHU;
						7'd15 :
									m_s <= en2 - 11'd90 + (11'd32 * Q2_2)- XIAYICANSHU;
						7'd16 :
									m_s <= en2 - 11'd90 + (11'd32 * Q2_1)- XIAYICANSHU;
						7'd17 :
									m_s <= en2 - 11'd90 + 11'd320- XIAYICANSHU;	
						7'd18 :
									m_s <= en2 - 11'd90 + (11'd32 * Q2_0)- XIAYICANSHU;
									
						7'd19 :
									m_s <= en2 - 11'd90 + (11'd32 * Q3_4)- XIAYICANSHU;					
						7'd20 :
									m_s <= en2 - 11'd90 + (11'd32 * Q3_3)- XIAYICANSHU;
						7'd21 :
									m_s <= en2 - 11'd90 + (11'd32 * Q3_2)- XIAYICANSHU;
						7'd22 :
									m_s <= en2 - 11'd90 + (11'd32 * Q3_1)- XIAYICANSHU;
						7'd23 :
									m_s <= en2 - 11'd90 + 11'd320- XIAYICANSHU;
						7'd24 :
									m_s <= en2 - 11'd90 + (11'd32 * Q3_0)- XIAYICANSHU;
									
						/////////////////////////////////////////////////////////二次谐波频率和幅值					
						7'd25 :
									m_s <= en2 - 11'd130 + (11'd32 * Q4_4)- XIAYICANSHU;
						7'd26 :
									m_s <= en2 - 11'd130 + (11'd32 * Q4_3)- XIAYICANSHU;
						7'd27 :
									m_s <= en2 - 11'd130 + (11'd32 * Q4_2)- XIAYICANSHU;
						7'd28 :
									m_s <= en2 - 11'd130 + (11'd32 * Q4_1)- XIAYICANSHU;
						7'd29 :
									m_s <= en2 - 11'd130 + 11'd320- XIAYICANSHU;	
						7'd30 :
									m_s <= en2 - 11'd130 + (11'd32 * Q4_0)- XIAYICANSHU;
									
						7'd31 :
									m_s <= en2 - 11'd130 + (11'd32 * Q5_4)- XIAYICANSHU;					
						7'd32 :
									m_s <= en2 - 11'd130 + (11'd32 * Q5_3)- XIAYICANSHU;
						7'd33 :
									m_s <= en2 - 11'd130 + (11'd32 * Q5_2)- XIAYICANSHU;
						7'd34 :
									m_s <= en2 - 11'd130 + (11'd32 * Q5_1)- XIAYICANSHU;
						7'd35 :
									m_s <= en2 - 11'd130 + 11'd320- XIAYICANSHU;
						7'd36 :
									m_s <= en2 - 11'd130 + (11'd32 * Q5_0)- XIAYICANSHU;
									
						/////////////////////////////////////////////////////////三次谐波频率和幅值					
						7'd37 :
									m_s <= en2 - 11'd170 + (11'd32 * Q6_4)- XIAYICANSHU;
						7'd38 :
									m_s <= en2 - 11'd170 + (11'd32 * Q6_3)- XIAYICANSHU;
						7'd39 :
									m_s <= en2 - 11'd170 + (11'd32 * Q6_2)- XIAYICANSHU;
						7'd40 :
									m_s <= en2 - 11'd170 + (11'd32 * Q6_1)- XIAYICANSHU;
						7'd41 :
									m_s <= en2 - 11'd170 + 11'd320- XIAYICANSHU;	
						7'd42 :
									m_s <= en2 - 11'd170 + (11'd32 * Q6_0)- XIAYICANSHU;
									
						7'd43 :
									m_s <= en2 - 11'd170 + (11'd32 * Q7_4)- XIAYICANSHU;					
						7'd44 :
									m_s <= en2 - 11'd170 + (11'd32 * Q7_3)- XIAYICANSHU;
						7'd45 :
									m_s <= en2 - 11'd170 + (11'd32 * Q7_2)- XIAYICANSHU;
						7'd46 :
									m_s <= en2 - 11'd170 + (11'd32 * Q7_1)- XIAYICANSHU;
						7'd47 :
									m_s <= en2 - 11'd170 + 11'd320- XIAYICANSHU;
						7'd48 :
									m_s <= en2 - 11'd170 + (11'd32 * Q7_0)- XIAYICANSHU;
									
						/////////////////////////////////////////////////////////四次谐波频率和幅值					
						7'd49 :
									m_s <= en2 - 11'd210 + (11'd32 * Q8_4)- XIAYICANSHU;
						7'd50 :
									m_s <= en2 - 11'd210 + (11'd32 * Q8_3)- XIAYICANSHU;
						7'd51 :
									m_s <= en2 - 11'd210 + (11'd32 * Q8_2)- XIAYICANSHU;
						7'd52 :
									m_s <= en2 - 11'd210 + (11'd32 * Q8_1)- XIAYICANSHU;
						7'd53 :
									m_s <= en2 - 11'd210 + 11'd320- XIAYICANSHU;	
						7'd54 :
									m_s <= en2 - 11'd210 + (11'd32 * Q8_0)- XIAYICANSHU;
									
						7'd55 :
									m_s <= en2 - 11'd210 + (11'd32 * Q9_4)- XIAYICANSHU;					
						7'd56 :
									m_s <= en2 - 11'd210 + (11'd32 * Q9_3)- XIAYICANSHU;
						7'd57 :
									m_s <= en2 - 11'd210 + (11'd32 * Q9_2)- XIAYICANSHU;
						7'd58 :
									m_s <= en2 - 11'd210 + (11'd32 * Q9_1)- XIAYICANSHU;
						7'd59 :
									m_s <= en2 - 11'd210 + 11'd320- XIAYICANSHU;
						7'd60 :
									m_s <= en2 - 11'd210 + (11'd32 * Q9_0)- XIAYICANSHU;
									
						/////////////////////////////////////////////////////////五次谐波频率和幅值					
						7'd61 :
									m_s <= en2 - 11'd250 + (11'd32 * Q10_4)- XIAYICANSHU;
						7'd62 :
									m_s <= en2 - 11'd250 + (11'd32 * Q10_3)- XIAYICANSHU;
						7'd63 :
									m_s <= en2 - 11'd250 + (11'd32 * Q10_2)- XIAYICANSHU;
						7'd64 :
									m_s <= en2 - 11'd250 + (11'd32 * Q10_1)- XIAYICANSHU;
						7'd65 :
									m_s <= en2 - 11'd250 + 11'd320- XIAYICANSHU;	
						7'd66 :
									m_s <= en2 - 11'd250 + (11'd32 * Q10_0)- XIAYICANSHU;
									
						7'd67 :
									m_s <= en2 - 11'd250 + (11'd32 * Q11_4)- XIAYICANSHU;					
						7'd68 :
									m_s <= en2 - 11'd250 + (11'd32 * Q11_3)- XIAYICANSHU;
						7'd69 :
									m_s <= en2 - 11'd250 + (11'd32 * Q11_2)- XIAYICANSHU;
						7'd70 :
									m_s <= en2 - 11'd250 + (11'd32 * Q11_1)- XIAYICANSHU;
						7'd71 :
									m_s <= en2 - 11'd250 + 11'd320- XIAYICANSHU;
						7'd72 :
									m_s <= en2 - 11'd250 + (11'd32 * Q11_0)- XIAYICANSHU;
						default : m_s <= 11'd0;
			 endcase
			
 reg	[10:0]		n_s;		
 always @(posedge clk or negedge rst_n)
	if (!rst_n)
		n_s <= 11'd0;
	else  
			 case(display_value_s)
					7'd1 : n_s <= en1 - 11'd472 ;
					7'd2 : n_s <= en1 - 11'd536 ;
					7'd3 : n_s <= en1 - 11'd600 ;
					7'd4 : n_s <= en1 - 11'd664 ;
					7'd5 : n_s <= en1 - 11'd728 ;
					7'd6 : n_s <= en1 - 11'd792 ;
					7'd7 : n_s <= en1 - 11'd1002 ;
					7'd8 : n_s <= en1 - 11'd1068 ;
					7'd9 : n_s <= en1 - 11'd1132 ;
					7'd10 : n_s <= en1 - 11'd1196 ;
					7'd11 : n_s <= en1 - 11'd1260 ;
					7'd12 : n_s <= en1 - 11'd1324 ;
					
					7'd13 : n_s <= en1 - 11'd472 ;
					7'd14 : n_s <= en1 - 11'd536 ;
					7'd15 : n_s <= en1 - 11'd600 ;
					7'd16 : n_s <= en1 - 11'd664 ;
					7'd17 : n_s <= en1 - 11'd728 ;
					7'd18 : n_s <= en1 - 11'd792 ;
					7'd19 : n_s <= en1 - 11'd1002 ;
					7'd20 : n_s <= en1 - 11'd1068 ;
					7'd21 : n_s <= en1 - 11'd1132 ;
					7'd22 : n_s <= en1 - 11'd1196 ;
					7'd23 : n_s <= en1 - 11'd1260 ;
					7'd24 : n_s <= en1 - 11'd1324 ;
					
					7'd25 : n_s <= en1 - 11'd472 ;
					7'd26 : n_s <= en1 - 11'd536 ;
					7'd27 : n_s <= en1 - 11'd600 ;
					7'd28 : n_s <= en1 - 11'd664 ;
					7'd29 : n_s <= en1 - 11'd728 ;
					7'd30 : n_s <= en1 - 11'd792 ;
					7'd31 : n_s <= en1 - 11'd1002 ;
					7'd32 : n_s <= en1 - 11'd1068 ;
					7'd33 : n_s <= en1 - 11'd1132 ;
					7'd34 : n_s <= en1 - 11'd1196 ;
					7'd35 : n_s <= en1 - 11'd1260 ;
					7'd36 : n_s <= en1 - 11'd1324 ;
					
					7'd37 : n_s <= en1 - 11'd472 ;
					7'd38 : n_s <= en1 - 11'd536 ;
					7'd39 : n_s <= en1 - 11'd600 ;
					7'd40 : n_s <= en1 - 11'd664 ;
					7'd41 : n_s <= en1 - 11'd728 ;
					7'd42 : n_s <= en1 - 11'd792 ;
					7'd43 : n_s <= en1 - 11'd1002 ;
					7'd44 : n_s <= en1 - 11'd1068 ;
					7'd45 : n_s <= en1 - 11'd1132 ;
					7'd46 : n_s <= en1 - 11'd1196 ;
					7'd47 : n_s <= en1 - 11'd1260 ;
					7'd48 : n_s <= en1 - 11'd1324 ;
					
					7'd49 : n_s <= en1 - 11'd472 ;
					7'd50 : n_s <= en1 - 11'd536 ;
					7'd51 : n_s <= en1 - 11'd600 ;
					7'd52 : n_s <= en1 - 11'd664 ;
					7'd53 : n_s <= en1 - 11'd728 ;
					7'd54 : n_s <= en1 - 11'd792 ;
					7'd55 : n_s <= en1 - 11'd1002 ;
					7'd56 : n_s <= en1 - 11'd1068 ;
					7'd57 : n_s <= en1 - 11'd1132 ;
					7'd58 : n_s <= en1 - 11'd1196 ;
					7'd59 : n_s <= en1 - 11'd1260 ;
					7'd60 : n_s <= en1 - 11'd1324 ;
					
					7'd61 : n_s <= en1 - 11'd472 ;
					7'd62 : n_s <= en1 - 11'd536 ;
					7'd63 : n_s <= en1 - 11'd600 ;
					7'd64 : n_s <= en1 - 11'd664 ;
					7'd65 : n_s <= en1 - 11'd728 ;
					7'd66 : n_s <= en1 - 11'd792 ;
					7'd67 : n_s <= en1 - 11'd1002 ;
					7'd68 : n_s <= en1 - 11'd1068 ;
					7'd69 : n_s <= en1 - 11'd1132 ;
					7'd70 : n_s <= en1 - 11'd1196 ;
					7'd71 : n_s <= en1 - 11'd1260 ;
					7'd72 : n_s <= en1 - 11'd1324 ;
					default : n_s <= 11'd0;
			endcase

/////////////////////////////////////////////////////////////


		
 /////////////////////////////////////////////总控制部分
 /////////////////////////////////////////////////////////汉字部分
 	reg    VGA_R_h;
	reg    VGA_G_h;
	reg    VGA_B_h;
	wire   display_value_H = 	(display_h_0 | display_h_1 | display_h_2 | display_h_3 
										| display_h_4 | display_h_5 | display_h_6
										| display_h_7 | display_h_8 | display_h_9
										| display_h_10 | display_h_11 | display_h_12
										| display_h_13 | display_h_14 | display_h_15 
										| display_h_16 | display_h_17 | display_h_18
										| display_h_19 | display_h_20 | display_h_21
										| display_h_22 | display_h_23 | display_h_24
										| display_h_25 | display_h_26 | display_h_27 | display_h_28 | display_h_29 | display_h_30 | display_h_31 | display_h_32 | display_h_33
										);
 always @(posedge clk or negedge rst_n)
	begin	
		if (!rst_n)
			begin
					VGA_R_h <= 1'b0;
					VGA_G_h <= 1'b0;
					VGA_B_h <= 1'b0;			
			end								
		else if (display_value_H)			/////更改此处控制显示位置							
			begin
					VGA_R_h <= Rom_Data_h['d63 - n_h];
					VGA_G_h <= Rom_Data_h['d63 - n_h];
					VGA_B_h <= Rom_Data_h['d63 - n_h];			
			end
	end	
			
 assign Rom_Addr_h = m_h[9:0];

 ////////////////////////////////单位部分
  	reg    VGA_R_d;
	reg    VGA_G_d;
	reg    VGA_B_d;
	wire   display_value_D = (display_d_0 | display_d_1 | display_d_2 | display_d_3 
										| display_d_4 | display_d_5 | display_d_6 | display_d_7 | display_d_14 | display_d_15 | display_d_8 | display_d_9 | display_d_10 | display_d_11 | display_d_12 | display_d_13);
 always @(posedge clk or negedge rst_n)
	begin	
		if (!rst_n)
			begin
					VGA_R_d <= 1'b0;
					VGA_G_d <= 1'b0;
					VGA_B_d <= 1'b0;			
			end								
		else if (display_value_D)			/////更改此处控制显示位置							
			begin
					VGA_R_d <= Rom_Data_d['d63 - n_d];
					VGA_G_d <= Rom_Data_d['d63 - n_d];
					VGA_B_d <= Rom_Data_d['d63 - n_d];			
			end
	end	
			
 assign Rom_Addr_d = m_d[7:0];
 ///////////////////////////////////////频率部分
  	reg    VGA_R_s;
	reg    VGA_G_s;
	reg    VGA_B_s;
	wire   display_value_S = ( | display_s0_0 | display_s0_1 | display_s0_2 | display_s0_3 | display_s0_4 | display_s0_5  
										| display_s0_6 | display_s0_7 | display_s0_8 | display_s0_9 | display_s0_10| display_s0_11				
										| display_s1_0 | display_s1_1 | display_s1_2 | display_s1_3 | display_s1_4 | display_s1_5  
										| display_s1_6 | display_s1_7 | display_s1_8 | display_s1_9 | display_s1_10| display_s1_11
										| display_s2_0 | display_s2_1 | display_s2_2 | display_s2_3 | display_s2_4 | display_s2_5 
										| display_s2_6 | display_s2_7 | display_s2_8 | display_s2_9 | display_s2_10| display_s2_11 
										| display_s3_0 | display_s3_1 | display_s3_2 | display_s3_3 | display_s3_4 | display_s3_5 
										| display_s3_6 | display_s3_7 | display_s3_8 | display_s3_9 | display_s3_10| display_s3_11
										| display_s4_0 | display_s4_1 | display_s4_2 | display_s4_3 | display_s4_4 | display_s4_5  
										| display_s4_6 | display_s4_7 | display_s4_8 | display_s4_9 | display_s4_10| display_s4_11
										| display_s5_0 | display_s5_1 | display_s5_2 | display_s5_3 | display_s5_4 | display_s5_5 
										| display_s5_6 | display_s5_7 | display_s5_8 | display_s5_9 | display_s5_10| display_s5_11																	
										);
										
 always @(posedge clk or negedge rst_n)
	begin	
		if (!rst_n)
			begin
					VGA_R_s <= 1'b0;
					VGA_G_s <= 1'b0;
					VGA_B_s <= 1'b0;			
			end								
		else if (display_value_S)			/////更改此处控制显示位置							
			begin
					VGA_R_s <= Rom_Data_s['d63 - n_s];
					VGA_G_s <= Rom_Data_s['d63 - n_s];
					VGA_B_s <= Rom_Data_s['d63 - n_s];			
			end
	end	
			
 assign Rom_Addr_s = m_s[8:0];
 //————————————————————————————————————————————
 //assign	rd_ram = (en2 >= 11'd 80 && en2 <= 11'd580) ? en1[9:0]:1'b0;

 

// assign VGA_R = (VGA_R_h | VGA_R_d | VGA_R_s | VGA_R_tz) ? 8'b1111_1111 : 8'b0000_0000;
// assign VGA_G = (VGA_G_h | VGA_G_d | VGA_G_s | VGA_G_tz) ? 8'b1111_1111 : 8'b0000_0000;
// assign VGA_B = (VGA_B_h | VGA_B_d | VGA_B_s | VGA_B_tz) ? 8'b1111_1111 : 8'b0000_0000;

 reg	 [7:0]		vga_r;
 reg	 [7:0]		vga_g;
 reg	 [7:0]		vga_b;
 
 wire		display_hanzi =  (VGA_R_h && VGA_G_h && VGA_B_h);
 wire		display_danwei = (VGA_R_d && VGA_G_d && VGA_B_d);
 wire		display_shuzi =  (VGA_R_s && VGA_G_s && VGA_B_s);
  

  
 wire	 [6:0]	state_vga = {display_title, display_shuzi,display_danwei,display_hanzi,displayline,wave};
 
 always @(posedge clk or negedge rst_n)
		if(!rst_n)
			begin
			vga_r <= 8'b0000_0000;
			vga_g <= 8'b0000_0000;
			vga_b <= 8'b0000_0000;
			end	
		else	
			begin
				case (state_vga)
					6'b000100 : begin
								vga_r <= 8'b1111_1111;			//‭CDAF95‬
								vga_g <= 8'b1010_0101;
								vga_b <= 8'b0100_1111;
						 end
					6'b001000 : begin
								vga_r <= 8'b1111_1111;			//黄色
								vga_g <= 8'b1111_1111;
								vga_b <= 8'b0000_0000;
						 end
					6'b010000 : begin
								vga_r <= 8'b1111_1111;			//‭CDAF95‬
								vga_g <= 8'b1010_0101;
								vga_b <= 8'b0100_1111;
						 end
					6'b000010 : begin
								vga_r <= 8'b1111_1111;			//CD3700
								vga_g <= 8'b1011_1011;
								vga_b <= 8'b1111_1111;
						 end
					6'b000011 : begin
								vga_r <= 8'hff;			//‭CDAF95‬
								vga_g <= 8'hff;
								vga_b <= 8'hff;
						 end
					6'b000001 : begin
								vga_r <= 8'hff;			//‭CDAF95‬
								vga_g <= 8'hff;
								vga_b <= 8'hff;
						 end
					6'b100000 : begin
								vga_r <= 8'b0111_0110;			//‭CDAF95‬
								vga_g <= 8'b1110_1110;
								vga_b <= 8'b10001011;
						 end
					default : begin
								vga_r <= 8'b0000_0000;
								vga_g <= 8'b0000_0000;
								vga_b <= 8'b0000_0000;
								 end
				endcase
			end


 //————————————————————————————————————
wire wave_sin = (en2 >= 11'd50 && en2 <= 11'd550) &&  (en1 == zx_P/4'd10 && en2 >= 11'd550 - zx_F/5'd20);
wire wave_notsin1 =  (en1 == (fzx_P   /4'd10)&& en2 <= 11'd550 && en2 >= 11'd550 - (fzx_F  /4'd10));
wire wave_notsin2 =  (en1 == (fzx_2_P /4'd10)&& en2 <= 11'd550 && en2 >= 11'd550 - (fzx_2_F/4'd10));
wire wave_notsin3 =  (en1 == (fzx_3_P /4'd10)&& en2 <= 11'd550 && en2 >= 11'd550 - (fzx_3_F/4'd10));
wire wave_notsin4 =  (en1 == (fzx_4_P /4'd10)&& en2 <= 11'd550 && en2 >= 11'd550 - (fzx_4_F/4'd10));
wire wave_notsin5 =  (en1 == (fzx_5_P /4'd10)&& en2 <= 11'd550 && en2 >= 11'd550 - (fzx_5_F/4'd10));
wire wave_notsin = wave_notsin2 || wave_notsin1|| wave_notsin3 || wave_notsin4 || wave_notsin5;

wire wave = (switch == 1'b1) ? wave_sin : wave_notsin;
 
 
 wire	displayline1 = (en2 >= 11'd615 + 32 && en2 <= 11'd617 + 32)|| (en2 >= 11'd553 && en1 >= 11'd350 && en1 <= 11'd352) || (en2 >= 11'd553 && en1 >= 11'd900 && en1 <= 11'd902) || (en2 >= 11'd550 && en2 <= 11'd553) ;
 
 wire	displayline2 = (en2 >= 11'd50 && en2 <= 11'd550) && (en1[1] == 1'b1 && en2[0] == 1'b1)?1'b1:1'b0;

 

 wire displayline = displayline1 | displayline2;
 
 assign VGA_R = vga_r;
 assign VGA_G = vga_g;
 assign VGA_B = vga_b;
 

 
endmodule