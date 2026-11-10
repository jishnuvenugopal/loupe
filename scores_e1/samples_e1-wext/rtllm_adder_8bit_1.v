
module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire cin,
    output reg [7:0] sum,
    output reg cout
);

    always @(*) begin
        sum = 0;
        cout = 0;

        for (int i = 0;
 i < 8;
 i++) begin
            sum[i] = a[i] ^ b[i] ^ cin;
            cout[i] = (a[i] & b[i]) | (a[i] & cin) | (b[i] & cin);
        end
    end

endmodule
