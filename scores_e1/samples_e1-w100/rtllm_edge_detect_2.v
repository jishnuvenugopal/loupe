
module edge_detect (
    input wire clk,
    input wire rst_n,
    input wire a,
    output reg rise,
    output reg down
);

    
    enum reg [1:0] {IDLE, RISING, FALLING} state;

    
    reg [1:0] prev_a;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            prev_a <= 2'b00;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (a == 1'b1) begin
                        state <= RISING;
                        prev_a <= a;
                        rise <= 1'b1;
                        down <= 1'b0;
                    end else if (a == 1'b0) begin
                        state <= FALLING;
                        prev_a <= a;
                        rise <= 1'b0;
                        down <= 1'b0;
                    end
                end
                RISING: begin
                    if (a == 1'b1) begin
                        prev_a <= a;
                    end else if (a == 1'b0) begin
                        state <= FALLING;
                        prev_a <= a;
                        rise <= 1'b0;
                        down <= 1'b1;
                    end
                end
                FALLING: begin
                    if (a == 1'b1) begin
                        state <= RISING;
                        prev_a <= a;
                        rise <= 1'b0;
                        down <= 1'b1;
                    end else if (a == 1'b0) begin
                        prev_a <= a;
                    end
                end
            endcase
        end
    end

endmodule
