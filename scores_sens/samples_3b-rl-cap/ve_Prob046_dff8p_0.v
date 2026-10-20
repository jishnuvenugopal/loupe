
module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  d,
    output reg  [7:0]  q
);

    
    reg [7:0] dff0, dff1, dff2, dff3, dff4, dff5, dff6, dff7;

    
    localparam [7:0] RESET_VALUE = 8'b110100;

    
    always @(negedge clk) begin
        if (reset) begin
            dff0 <= RESET_VALUE;
            dff1 <= RESET_VALUE;
            dff2 <= RESET_VALUE;
            dff3 <= RESET_VALUE;
            dff4 <= RESET_VALUE;
            dff5 <= RESET_VALUE;
            dff6 <= RESET_VALUE;
            dff7 <= RESET_VALUE;
        end else begin
            dff0 <= d[0];
            dff1 <= d[1];
            dff2 <= d[2];
            dff3 <= d[3];
            dff4 <= d[4];
            dff5 <= d[5];
            dff6 <= d[6];
            dff7 <= d[7];
        end
    end

    
    assign q = {dff7, dff6, dff5, dff4, dff3, dff2, dff1, dff0};

endmodule
