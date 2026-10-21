
module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg [1:0] state;
    reg [1:0] next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;
        end else begin
            case (state)
                2'b00: begin
                    if (in == 0 && areset == 1) begin
                        next_state <= 2'b01;
                    end else if (in == 0 && areset == 0) begin
                        next_state <= 2'b00;
                    end else if (in == 1 && areset == 1) begin
                        next_state <= 2'b01;
                    end else if (in == 1 && areset == 0) begin
                        next_state <= 2'b00;
                    end
                end
                2'b01: begin
                    next_state <= 2'b01;
                end
            endcase
            state <= next_state;
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            out <= 1'b0;
        end else begin
            out <= state[0];
        end
    end

endmodule
