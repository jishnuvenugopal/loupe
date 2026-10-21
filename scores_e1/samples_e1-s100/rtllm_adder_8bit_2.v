
module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire cin,
    output reg [7:0] sum,
    output reg cout
);

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            sum <= 8'b0;
            cout <= 1'b0;
        end else begin
            for (int i = 0;
 i < 8;
 i = i + 1) begin
                reg [7:0] bit_sum;
                reg [1:0] bit_cout;

                bit_sum = a[i] ^ b[i] ^ cin;
                bit_cout = (a[i] & b[i]) | (a[i] & cin) | (b[i] & cin);

                sum[i] <= bit_sum;
                cout <= bit_cout;
            end
        end
    end

endmodule
