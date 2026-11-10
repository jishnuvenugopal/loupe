
module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

    reg [3:0] state;
    reg [1:0] count;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= 4'b0000;
            count <= 2'b00;
            MATCH <= 0;
        end else begin
            case (state)
                4'b0000: begin
                    if (IN == 1) begin
                        state <= 4'b0001;
                        count <= 2'b00;
                    end else begin
                        state <= 4'b0000;
                    end
                end
                4'b0001: begin
                    if (IN == 1) begin
                        count <= count + 1;
                    end else begin
                        count <= 2'b00;
                    end
                    if (count == 4'b1111) begin
                        MATCH <= 1;
                    end
                end
                4'b0010: begin
                    if (IN == 1) begin
                        count <= count + 1;
                    end else begin
                        count <= 2'b00;
                    end
                    if (count == 4'b1111) begin
                        MATCH <= 1;
                    end
                end
                4'b0011: begin
                    if (IN == 1) begin
                        count <= count + 1;
                    end else begin
                        count <= 2'b00;
                    end
                    if (count == 4'b1111) begin
                        MATCH <= 1;
                    end
                end
                4'b0100: begin
                    if (IN == 1) begin
                        count <= count + 1;
                    end else begin
                        count <= 2'b00;
                    end
                    if (count == 4'b1111) begin
                        MATCH <= 1;
                    end
                end
                4'b0101: begin
                    if (IN == 1) begin
                        count <= count + 1;
                    end else begin
                        count <= 2'b00;
                    end
                    if (count == 4'b1111) begin
                        MATCH <= 1;
                    end
                end
                4'b0110: begin
                    if (IN == 1) begin
                        count <= count + 1;
                    end else begin
                        count <= 2'b00;
                    end
                    if (count == 4'b1111) begin
                        MATCH <= 1;
                    end
                end
                4'b0111: begin
                    if (IN == 1) begin
                        count <= count + 1;
                    end else begin
                        count <= 2'b00;
                    end
                    if (count == 4'b1111) begin
                        MATCH <= 1;
                    end
                end
                4'b1000: begin
                    if (IN == 1) begin
                        state <= 4'b0001;
                        count <= 2'b00;
                    end else begin
                        state <= 4'b1000;
                    end
                end
                4'b1001: begin
                    if (IN == 1) begin
                        count <= count + 1;
                    end else begin
                        count <= 2'b00;
                    end
                    if (count == 4'b1111) begin
                        MATCH <= 1;
                    end
                end
                4'b1010: begin
                    if (IN == 1) begin
                        count <= count + 1;
                    end else begin
                        count <= 2'b00;
                    end
                    if (count == 4'b1111) begin
                        MATCH <= 1;
                    end
                end
                4'b1011: begin
                    if (IN == 1) begin
                        count <= count + 1;
                    end else begin
                        count <= 2'b00;
                    end
                    if (count == 4'b1111) begin
                        MATCH <= 1;
                    end
                end
                4'b1100: begin
                    if (IN == 1) begin
                        count <= count + 1;
                    end else begin
                        count <= 2'b00;
                    end
                    if (count == 4'b1111) begin
                        MATCH <= 1;
                    end
                end
                4'b1101: begin
                    if (IN == 1) begin
                        count <= count + 1;
                    end else begin
                        count <= 2'b00;
                    end
                    if (count == 4'b1111) begin
                        MATCH <= 1;
                    end
                end
                4'b1110: begin
                    if (IN == 1) begin
                        count <= count + 1;
                    end else begin
                        count <= 2'b00;
                    end
                    if (count == 4'b1111) begin
                        MATCH <= 1;
                    end
                end
                4'b1111: begin
                    if (IN == 1) begin
                        count <= count + 1;
                    end else begin
                        count <= 2'b00;
                    end
                    if (count == 4'b1111) begin
                        MATCH <= 1;
                    end
                end
                default: begin
                    state <= 4'b0000;
                    count <= 2'b00;
                    MATCH <= 0;
                end
            endcase
        end
    end

endmodule
