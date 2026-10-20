
module TopModule (
    input clk,
    input rst,
    input [7:0] code,
    output reg [3:0] out,
    output reg valid
);

    
    reg [9:0] keycodes = 10'b1111111111;
    reg [3:0] keynum;
    reg keyvalid;

    always @(posedge clk) begin
        if (rst) begin
            keynum <= 4'b0;
            keyvalid <= 1'b0;
            out <= 4'b0;
            valid <= 1'b0;
        end else begin
            case (code)
                8'h45: begin
                    keynum <= 4'b0;
                    keyvalid <= 1'b1;
                end
                8'h16: begin
                    keynum <= 4'b1;
                    keyvalid <= 1'b1;
                end
                8'h1e: begin
                    keynum <= 4'b2;
                    keyvalid <= 1'b1;
                end
                8'h26: begin
                    keynum <= 4'b3;
                    keyvalid <= 1'b1;
                end
                8'h25: begin
                    keynum <= 4'b4;
                    keyvalid <= 1'b1;
                end
                8'h2e: begin
                    keynum <= 4'b5;
                    keyvalid <= 1'b1;
                end
                8'h36: begin
                    keynum <= 4'b6;
                    keyvalid <= 1'b1;
                end
                8'h3d: begin
                    keynum <= 4'b7;
                    keyvalid <= 1'b1;
                end
                8'h3e: begin
                    keynum <= 4'b8;
                    keyvalid <= 1'b1;
                end
                8'h46: begin
                    keynum <= 4'b9;
                    keyvalid <= 1'b1;
                end
                default: begin
                    keynum <= 4'b0;
                    keyvalid <= 1'b0;
                end
            endcase
            out <= keynum;
            valid <= keyvalid;
        end
    end

endmodule
