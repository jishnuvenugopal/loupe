
module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    
    reg [1:0] current_state;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= 2'b00;
            z <= 1'b0;
        end else begin
            case (current_state)
                2'b00: begin
                    if (x) begin
                        current_state <= 2'b01;
                        z <= 1'b0;
                    end else begin
                        current_state <= 2'b00;
                        z <= 1'b0;
                    end
                end
                2'b01: begin
                    if (x) begin
                        current_state <= 2'b10;
                        z <= 1'b0;
                    end else begin
                        current_state <= 2'b01;
                        z <= 1'b0;
                    end
                end
                2'b10: begin
                    if (x) begin
                        current_state <= 2'b11;
                        z <= 1'b0;
                    end else begin
                        current_state <= 2'b10;
                        z <= 1'b0;
                    end
                end
                2'b11: begin
                    current_state <= 2'b00;
                    z <= 1'b1;
                end
            endcase
        end
    end

    
    always @(*) begin
        case (current_state)
            2'b00: z <= 1'b0;
            2'b01: z <= 1'b1;
            2'b10: z <= 1'b0;
            2'b11: z <= 1'b1;
        endcase
    end

endmodule
