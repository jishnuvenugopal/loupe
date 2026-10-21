
module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    
    reg [3:0] d;
    reg [3:0] q;

    
    assign d = in;

    
    always @(posedge clk) begin
        q <= d;
    end

    
    always @(posedge resetn) begin
        q <= 4'b0000;
    end

    
    assign out = q;

endmodule
