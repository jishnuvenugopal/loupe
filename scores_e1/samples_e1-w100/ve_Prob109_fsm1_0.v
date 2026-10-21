
module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg [1:0] state;
    reg reset;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;
            reset <= 1'b1;
        end else begin
            reset <= 1'b0;
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
                2'b10: begin
                    if (in == 0) begin
                        state <= 2'b11;
                    end else begin
                        state <= 2'b10;
                    end
                end
                2'b11: begin
                    if (in == 0) begin
                        state <= 2'b10;
                    end else begin
                        state <= 2'b11;
                    end
                end
            endcase
        end
    end

    always @(posedge clk) begin
        out <= state[0];
    end

endmodule
