
module TopModule (
    input  wire        clk,
    input  wire        resetn,
    input  wire [1:0]  byteena,
    input  wire [15:0] d,
    output reg  [15:0] q
);

    
    reg [15:0] dff;

    always @(posedge clk) begin
        if (!resetn) begin
            dff <= 16'b0;
        end else begin
            
            dff[15]   = (byteena[1] ? d[15]   : dff[15]);
            dff[14:8] = (byteena[1] ? d[14:8] : dff[14:8]);
            dff[7:0]  = (byteena[0] ? d[7:0]  : dff[7:0]);
        end
    end

    assign q = dff;

endmodule
