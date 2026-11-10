
module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

    reg [3:0] state;
    reg [1:0] last_state;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= 4'b0000;
            MATCH <= 1'b0;
        end else begin
            case (state)
                4'b0000: begin
                    if (IN == 1'b1) begin
                        state <= 4'b0001;
                    end
                end
                4'b0001: begin
                    if (IN == 1'b0) begin
                        state <= 4'b0010;
                    end
                end
                4'b0010: begin
                    if (IN == 1'b0) begin
                        state <= 4'b0011;
                    end
                end
                4'b0011: begin
                    if (IN == 1'b1) begin
                        state <= 4'b0100;
                    end
                end
                4'b0100: begin
                    if (IN == 1'b1) begin
                        state <= 4'b0101;
                    end
                end
                4'b0101: begin
                    if (IN == 1'b0) begin
                        state <= 4'b0110;
                    end
                end
                4'b0110: begin
                    if (IN == 1'b0) begin
                        state <= 4'b0111;
                    end
                end
                4'b0111: begin
                    if (IN == 1'b1) begin
                        state <= 4'b1000;
                    end
                end
                4'b1000: begin
                    if (IN == 1'b1) begin
                        state <= 4'b1001;
                    end
                end
                4'b1001: begin
                    if (IN == 1'b1) begin
                        state <= 4'b1010;
                    end
                end
                4'b1010: begin
                    if (IN == 1'b0) begin
                        state <= 4'b1011;
                    end
                end
                4'b1011: begin
                    if (IN == 1'b0) begin
                        state <= 4'b1100;
                    end
                end
                4'b1100: begin
                    if (IN == 1'b0) begin
                        state <= 4'b1101;
                    end
                end
                4'b1101: begin
                    if (IN == 1'b0) begin
                        state <= 4'b1110;
                    end
                end
                4'b1110: begin
                    if (IN == 1'b0) begin
                        state <= 4'b1111;
                    end
                end
                4'b1111: begin
                    if (IN == 1'b1) begin
                        state <= 4'b0000;
                    end
                end
            endcase

            if (state == 4'b0001) begin
                MATCH <= 1'b1;
            end else begin
                MATCH <= 1'b0;
            end
        end
    end

endmodule
