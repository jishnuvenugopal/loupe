
module TopModule (
    input wire clk,
    input wire areset,
    input wire j,
    input wire k,
    output reg out
);

    
    reg [1:0] current_state;
    reg [1:0] next_state;

    
    initial begin
        current_state = 2'b00;
        out = 0;
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= 2'b00;
            out <= 0;
        end else begin
            case (current_state)
                2'b00: begin
                    if (j == 1) begin
                        next_state = 2'b01;
                    end else begin
                        next_state = 2'b00;
                    end
                end
                2'b01: begin
                    if (k == 1) begin
                        next_state = 2'b00;
                    end else begin
                        next_state = 2'b10;
                    end
                end
                2'b10: begin
                    next_state = 2'b10;
                end
                default: begin
                    next_state = 2'b00;
                end
            endcase

            
            current_state <= next_state;

            
            case (current_state)
                2'b00: out <= 0;
                2'b01: out <= 1;
                2'b10: out <= 1;
                default: out <= 0;
            endcase
        end
    end

endmodule
