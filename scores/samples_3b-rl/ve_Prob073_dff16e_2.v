
module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire [1:0] byteena,
    input  wire [15:0] d,
    output reg [15:0] q
);

    
    reg [15:0] dff;

    always @(posedge clk) begin
        if (!resetn) begin
            
            dff <= 16'b0;
        end else begin
            
            case (byteena)
                2'b00: dff <= {d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15]};
                2'b01: dff <= {d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[7]};
                2'b10: dff <= {d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[0]};
                2'b11: dff <= {d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15], d[15]};
                default: dff <= d;
            endcase
        end
    end

    assign q = dff;

endmodule
