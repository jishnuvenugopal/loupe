
module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    
    
    
    
    
    
    reg [3:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state   <= 4'd0;
            out_bytes <= 24'd0;
            done    <= 1'b0;
        end else begin
            case (state)
                4'd0: begin 
                    if (in[3])
                        state <= 4'd1;
                    else
                        state <= 4'd0;
                end
                4'd1: begin 
                    out_bytes[23:16] <= in;
                    state <= 4'd2;
                end
                4'd2: begin 
                    out_bytes[15:8] <= in;
                    state <= 4'd3;
                end
                4'd3: begin 
                    out_bytes[7:0] <= in;
                    state <= 4'd4;
                end
                4'd4: begin 
                    done <= 1'b1;
                    state <= 4'd0;
                end
                default: state <= 4'd0;
            endcase
        end
    end

endmodule
