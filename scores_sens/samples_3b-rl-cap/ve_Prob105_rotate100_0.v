
module TopModule (
    input  wire        clk,
    input  wire        load,
    input  wire [1:0]  ena,
    input  wire [99:0] data,
    output reg  [99:0] q
);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (ena == 2'b01) begin
        
        q <= {q[98:0], q[0]};
    end else if (ena == 2'b10) begin
        
        q <= {q[99], q[98:0]};
    end
    
end








endmodule
