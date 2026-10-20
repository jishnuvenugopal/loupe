
module radix2_div (
    input wire clk,
    input wire rst,
    input wire sign,
    input wire [7:0] dividend,
    input wire [7:0] divisor,
    input wire opn_valid,
    input wire res_ready,
    output reg res_valid,
    output reg [15:0] result
);

    reg [7:0] SR;
    reg [7:0] ABS_DIVISOR;
    reg [7:0] ABS_DIVIDEND;
    reg [7:0] NEG_DIVISOR;
    reg [2:0] cnt;
    reg start_cnt;

    wire [7:0] SUB_RES;
    wire carry_out;

    assign ABS_DIVIDEND = sign ? 8'b0 : dividend;
    assign ABS_DIVISOR = sign ? 8'b0 : divisor;
    assign NEG_DIVISOR = sign ? -ABS_DIVISOR : ABS_DIVISOR;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 8'b0;
            ABS_DIVISOR <= 8'b0;
            ABS_DIVIDEND <= 8'b0;
            NEG_DIVISOR <= 8'b0;
            cnt <= 3'b0;
            start_cnt <= 1'b0;
            res_valid <= 1'b0;
            result <= 16'b0;
        end else begin
            if (opn_valid && ~res_valid) begin
                SR <= {ABS_DIVIDEND, 1'b0};
                ABS_DIVISOR <= ABS_DIVISOR;
                NEG_DIVISOR <= NEG_DIVISOR;
                cnt <= 3'b0;
                start_cnt <= 1'b1;
            end

            if (start_cnt) begin
                if (cnt == 8'b111) begin
                    cnt <= 3'b0;
                    start_cnt <= 1'b0;
                    SR <= {SR[6:0], carry_out};
                    result <= {SR, ABS_DIVIDEND};
                end else begin
                    SUB_RES <= SR - NEG_DIVISOR;
                    carry_out <= SR[7];
                    SR <= {SUB_RES[6:0], carry_out};
                    cnt <= cnt + 1;
                end
            end

            if (res_ready) begin
                res_valid <= 1'b0;
            end else begin
                res_valid <= (cnt == 8'b0) ? 1'b0 : 1'b1;
            end
        end
    end

endmodule
