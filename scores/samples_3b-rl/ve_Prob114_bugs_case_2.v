
module TopModule (
    input  wire        clk,
    input  wire        rst,
    input  wire [7:0]  code,
    output reg  [3:0]  out,
    output reg         valid
);

    
    reg [9:0] key_code;

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            key_code <= 10'd0;
            out      <= 4'd0;
            valid    <= 1'b0;
        end else begin
            case (code)
                8'h45: begin 
                    key_code <= {code, key_code[9:1]};
                    out      <= 4'd0;
                    valid    <= 1'b1;
                end
                8'h16: begin 
                    key_code <= {code, key_code[9:1]};
                    out      <= 4'd1;
                    valid    <= 1'b1;
                end
                8'h1e: begin 
                    key_code <= {code, key_code[9:1]};
                    out      <= 4'd2;
                    valid    <= 1'b1;
                end
                8'h26: begin 
                    key_code <= {code, key_code[9:1]};
                    out      <= 4'd3;
                    valid    <= 1'b1;
                end
                8'h25: begin 
                    key_code <= {code, key_code[9:1]};
                    out      <= 4'd4;
                    valid    <= 1'b1;
                end
                8'h2e: begin 
                    key_code <= {code, key_code[9:1]};
                    out      <= 4'd5;
                    valid    <= 1'b1;
                end
                8'h36: begin 
                    key_code <= {code, key_code[9:1]};
                    out      <= 4'd6;
                    valid    <= 1'b1;
                end
                8'h3d: begin 
                    key_code <= {code, key_code[9:1]};
                    out      <= 4'd7;
                    valid    <= 1'b1;
                end
                8'h3e: begin 
                    key_code <= {code, key_code[9:1]};
                    out      <= 4'd8;
                    valid    <= 1'b1;
                end
                8'h46: begin 
                    key_code <= {code, key_code[9:1]};
                    out      <= 4'd9;
                    valid    <= 1'b1;
                end
                default: begin
                    out      <= 4'd0;
                    valid    <= 1'b0;
                end
            endcase
        end
    end

endmodule
