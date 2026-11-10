
module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

    reg [3:0] count;
    reg state;

    always @(posedge clk or posedge rst_n) begin
        if (rst_n) begin
            count <= 4'b0000;
            state <= 'b0;
        end else begin
            case (state)
                'b0: begin
                    if (valid_count) begin
                        state <= 'b1;
                        count <= 4'b0000;
                    end
                end
                'b1: begin
                    if (count == 4'b11) begin
                        count <= 4'b0000;
                    end else begin
                        count <= count + 1;
                    end
                end
            endcase
        end
    end

    assign out = count;

endmodule
