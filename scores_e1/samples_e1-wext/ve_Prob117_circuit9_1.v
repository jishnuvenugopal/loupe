
module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

    reg [1:0] state;

    always @(posedge clk) begin
        case (state)
            2'b00: begin
                if (a == 1) begin
                    state <= 2'b01;
                end else begin
                    state <= 2'b00;
                end
            end
            2'b01: begin
                if (a == 1) begin
                    state <= 2'b01;
                end else begin
                    state <= 2'b00;
                end
            end
            default: state <= 2'b00;
        endcase

        if (state == 2'b01) begin
            q <= 3'b010;
        end else begin
            q <= 3'b000;
        end
    end

endmodule
