
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire [7:0] in,
    output reg  done
);

    
    
    
    
    
    reg [3:0] state;

    
    reg [31:0] bytes;

    
    reg [1:0] byte_index;

    
    always @(posedge clk) begin
        if (reset) begin
            state   <= 4'd0;
            done    <= 1'b0;
            bytes   <= 32'd0;
            byte_index <= 2'd0;
        end else begin
            case (state)
                4'd0: begin
                    
                    if (in[3])
                        state <= 4'd1;
                    else
                        state <= 4'd0;
                end
                4'd1: begin
                    
                    bytes[23:16] <= in;
                    state <= 4'd2;
                    byte_index <= 2'd1;
                end
                4'd2: begin
                    
                    bytes[15:8] <= in;
                    state <= 4'd3;
                    byte_index <= 2'd2;
                end
                4'd3: begin
                    
                    bytes[7:0] <= in;
                    state <= 4'd4;
                    byte_index <= 2'd3;
                    
                    done <= 1'b1;
                end
                default: begin
                    state <= 4'd0;
                    done <= 1'b0;
                    bytes <= 32'd0;
                    byte_index <= 2'd0;
                end
            endcase
        end
    end

endmodule
