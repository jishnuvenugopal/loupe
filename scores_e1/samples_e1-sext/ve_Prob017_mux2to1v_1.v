
module TopModule (
    input wire [9:0] a,  
    input wire [9:0] b,  
    input wire sel,     
    output reg [9:0] out  
);


always @(*) begin
    if (sel == 0) begin
        out = a;
  
    end else begin
        out = b;
  
    end
end

endmodule
