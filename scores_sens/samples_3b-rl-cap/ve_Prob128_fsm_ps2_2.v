
module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    
    reg [7:0] in1, in2, in3;
    reg [3:0] state;

    
    
    
    
    

    always @(posedge clk) begin
        if (reset) begin
            state   <= 4'd0;
            in1     <= 8'd0;
            in2     <= 8'd0;
            in3     <= 8'd0;
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
                    in1 <= in;
                    state <= 4'd2;
                end
                4'd2: begin 
                    in2 <= in;
                    state <= 4'd3;
                end
                4'd3: begin 
                    in3 <= in;
                    state <= 4'd0;
                    done <= 1'b1;
                end
                default: state <= 4'd0;
            endcase
        end
    end

endmodule
