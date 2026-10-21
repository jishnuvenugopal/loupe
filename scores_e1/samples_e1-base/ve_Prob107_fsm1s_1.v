
module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    
    reg [1:0] state;

    
    initial begin
        state = 2'b00;
 
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
 
        end else begin
            case (state)
                2'b00: begin
                    if (in == 0) begin
                        state <= 2'b01;
 
                    end else begin
                        state <= 2'b00;
 
                    end
                end
                2'b01: begin
                    if (in == 0) begin
                        state <= 2'b00;
 
                    end else begin
                        state <= 2'b01;
 
                    end
                end
                default: begin
                    state <= 2'b00;
 
                end
            endcase
        end
    end

    
    always @(*) begin
        out = state[0];
 
    end

endmodule
