
module TopModule (
    input wire [7:0] code,
    input wire valid,
    output reg [3:0] out,
    output reg valid_out
);

always @(*) begin
    case (code)
        8'h45: begin
            out = 4'b0;
            valid_out = 1'b1;
        end
        8'h16: begin
            out = 4'b1;
            valid_out = 1'b1;
        end
        8'h1e: begin
            out = 4'b2;
            valid_out = 1'b1;
        end
        8'h26: begin
            out = 4'b3;
            valid_out = 1'b1;
        end
        8'h25: begin
            out = 4'b4;
            valid_out = 1'b1;
        end
        8'h2e: begin
            out = 4'b5;
            valid_out = 1'b1;
        end
        8'h36: begin
            out = 4'b6;
            valid_out = 1'b1;
        end
        8'h3d: begin
            out = 4'b7;
            valid_out = 1'b1;
        end
        8'h3e: begin
            out = 4'b8;
            valid_out = 1'b1;
        end
        8'h46: begin
            out = 4'b9;
            valid_out = 1'b1;
        end
        default: begin
            out = 4'b0;
            valid_out = 1'b0;
        end
    endcase
end

endmodule
