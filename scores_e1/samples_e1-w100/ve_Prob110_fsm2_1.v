
module TopModule (
    input clk,
    input areset,
    input j,
    input k,
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
                    if (j == 0) begin
                        next_state = 2'b00;
                        out = 0;
                    end else if (j == 1) begin
                        next_state = 2'b01;
                        out = 1;
                    end
                end
                2'b01: begin
                    if (k == 0) begin
                        next_state = 2'b01;
                        out = 1;
                    end else if (k == 1) begin
                        next_state = 2'b00;
                        out = 0;
                    end
                end
            endcase
            current_state <= next_state;
        end
    end

endmodule
