
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
    reg [7:0] NEG_DIVISOR;
    reg [2:0] cnt;
    reg start_cnt;
    reg [1:0] temp;
    reg carry;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 8'b0;
            NEG_DIVISOR <= 8'b0;
            cnt <= 3'b0;
            start_cnt <= 1'b0;
            res_valid <= 1'b0;
            result <= 16'b0;
        end else begin
            if (opn_valid && ~res_valid) begin
                SR <= (sign && (dividend[7] ^ divisor[7])) ? (dividend << 1) + 1 : (dividend << 1);
                NEG_DIVISOR <= (dividend[7] ^ divisor[7]) ? (-(divisor + 1)) : (-divisor);
                cnt <= 3'b1000;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
            end else if (start_cnt) begin
                if (cnt == 3'b1000) begin
                    cnt <= 3'b0;
                    start_cnt <= 1'b0;
                    result[15:8] <= SR[7:0];
                    result[7:0] <= NEG_DIVISOR[7:0];
                end else begin
                    temp <= SR - NEG_DIVISOR;
                    if (temp[7] != SR[7]) begin
                        SR <= temp;
                        carry <= 1'b1;
                    end else begin
                        SR <= temp << 1;
                        carry <= 1'b0;
                    end
                    cnt <= cnt + 1;
                end
            end else if (res_ready) begin
                res_valid <= 1'b0;
            end
        end
    end

endmodule
