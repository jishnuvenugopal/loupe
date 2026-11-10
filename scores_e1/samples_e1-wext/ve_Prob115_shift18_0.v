
module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

    
    always @(posedge clk or posedge load) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            case (amount)
                2'b00: q <= {q[63:1], q[0]};
                2'b01: q <= {q[63:8], q[0:7]};
                2'b10: q <= {q[63:1], q[0]};
                2'b11: q <= {q[63:8], q[0:7]};
            endcase
        end
    end

endmodule
