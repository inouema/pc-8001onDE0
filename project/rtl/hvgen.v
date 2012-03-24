


module HVGEN (
              input  CLK, // 25MHz
              input  RST, // High Active
              output reg HS,
              output reg VS,
              output reg [ 9:0] H_CNT,
              output reg [ 9:0] V_CNT
              );

   // 水平カウンタ
   parameter         HMAX = 800;
   wire              hcntend = (H_CNT == HMAX-10'h001);

   always @ (posedge CLK, posedge RST) begin
      if ( RST )
        H_CNT <= 10'h000;
      else if(hcntend)
        H_CNT <= 10'h000;
      else
        H_CNT <= H_CNT + 10'h001;
   end

   // 垂直カウンタ
   parameter VMAX = 525;

   always @(posedge CLK, posedge RST) begin
      if ( RST )
        V_CNT <= 10'h000;
      else if( hcntend ) begin
         if (V_CNT == VMAX - 10'h001)
           V_CNT <= 10'h000;
         else
           V_CNT <= V_CNT + 10'h001;
      end
   end


   // 同期信号
   //parameter HS_START = 663;
   //parameter HS_END   = 759;
   parameter HS_START = 656;
   parameter HS_END   = 752;
   parameter VS_START = 449;
   parameter VS_END   = 451;

   always @( posedge CLK or posedge RST) begin
      if ( RST )
        HS <= 1'b1;
      else if( H_CNT == HS_START )
        HS <= 1'b0;
      else if( H_CNT == HS_END )
        HS <= 1'b1;
   end

   always @( posedge CLK or posedge RST) begin
      if ( RST )
        VS <= 1'b1;
      else if(H_CNT == HS_START) begin
         if( V_CNT == VS_START )
           VS <= 1'b0;
         else if ( V_CNT == VS_END)
           VS <= 1'b1;
      end
   end

endmodule // HVGEN
