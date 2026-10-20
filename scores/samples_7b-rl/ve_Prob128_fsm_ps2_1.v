
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);
    reg [1:0] state;
    reg done_reg;
    
    localparam IDLE = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b10;
    localparam S3 = 2'b11;
    
    assign done = done_reg;
    
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done_reg <= 0;
        end else begin
            done_reg <= 0;
            case (state)
                IDLE: begin
                    if (in[3]) 
                        state <= S1;
                    else
                        state <= IDLE;
                end
                S1: state <= S2;
 
                S2: state <= S3;
 
                S3: begin       
                    done_reg <= 1;
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
