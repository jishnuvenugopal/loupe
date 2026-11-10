
module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire cin,
    output reg [7:0] sum,
    output reg cout
);

    
    always @(*) begin
        if (cin == 1'b0) begin
            sum = a + b;
            cout = a[7] ^ b[7] ^ cin;
        end else begin
            sum = a + b + cin;
            cout = a[7] ^ b[7] ^ a[6] ^ b[6] ^ cin;
        end
    end

endmodule
