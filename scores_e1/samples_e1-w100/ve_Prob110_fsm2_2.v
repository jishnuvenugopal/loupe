
module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

    
    reg [1:0] state;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;
 
            out <= 1'b0;
        end else begin
            case (state)
                2'b00: begin
                    if (j == 1) begin
                        state <= 2'b01;
 
                    end else begin
                        state <= 2'b00;
 
                    end
                end
                2'b01: begin
                    if (k == 0) begin
                        state <= 2'b01;
 
                    end else begin
                        state <= 2'b00;
 
                    end
                end
                default: begin
                    state <= 2'b00;
 
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            out <= 1'b0;
        end else begin
            out <= state[1];
 
        end
    end

endmodule
