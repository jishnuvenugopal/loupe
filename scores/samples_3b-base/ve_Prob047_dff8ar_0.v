
module TopModule (
    input  clk,
    input  areset,
    input  [7:0] d,
    output [7:0] q
);

    
    reg [7:0] dff0, dff1, dff2, dff3, dff4, dff5, dff6, dff7;

    
    reg reset;
    assign reset = areset;

    
    reg [7:0] ce;

    
    reg [7:0] q_sync;

    
    always @(posedge clk) begin
        ce = 1'b1;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            dff0 <= 8'b0;
            dff1 <= 8'b0;
            dff2 <= 8'b0;
            dff3 <= 8'b0;
            dff4 <= 8'b0;
            dff5 <= 8'b0;
            dff6 <= 8'b0;
            dff7 <= 8'b0;
        end else begin
            dff0 <= d[0] & ce;
            dff1 <= d[1] & ce;
            dff2 <= d[2] & ce;
            dff3 <= d[3] & ce;
            dff4 <= d[4] & ce;
            dff5 <= d[5] & ce;
            dff6 <= d[6] & ce;
            dff7 <= d[7] & ce;
        end
    end

    
    always @(posedge clk) begin
        q_sync <= dff7;
    end

    
    assign q = q_sync;

endmodule
