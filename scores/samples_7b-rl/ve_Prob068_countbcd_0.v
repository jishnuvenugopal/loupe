
module TopModule (
    input clk,
    input reset,
    output [3:0] ena,
    output [15:0] q
);
    reg [3:0] d0, d1, d2, d3;
    wire carry0, carry1, carry2;
    
    
    assign d0 = (reset || (d0 ==4'd9)) ?4'd0 :d0 +1;
    
    
    assign carry0 = (d0 ==4'd9);
    
    
    assign d1 = (reset || carry0) ?4'd0 : ((carry0 && d1 ==4'd9) ?4'd0 :d1 +1);
    
    
    assign carry1 = carry0 && (d1 ==4'd9);
    
    
    assign d2 = (reset || carry1) ?4'd0 : ((carry1 && d2 ==4'd9) ?4'd0 :d2 +1);
    
    
    assign carry2 = carry1 && (d2 ==4'd9);
    
    
    assign d3 = (reset || carry2) ?4'd0 : ((carry2 && d3 ==4'd9) ?4'd0 :d3 +1);
    
    
    assign ena = {carry2, carry1, carry0, 1'b0};
 
    
    
    assign q = {d3, d2, d1, d0};
    
    
    always @(posedge clk) begin
        d0 <= (reset || (d0 ==4'd9)) ?4'd0 :d0 +1;
        d1 <= (reset || carry0) ?4'd0 :d1;
        d2 <= (reset || carry1) ?4'd0 :d2;
        d3 <= (reset || carry2) ?4'd0 :d3;
    end  
endmodule
