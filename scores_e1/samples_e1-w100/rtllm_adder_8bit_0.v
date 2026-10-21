
module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire cin,
    output reg [7:0] sum,
    output reg cout
);


module full_adder (
    input wire a,
    input wire b,
    input wire cin,
    output reg sum,
    output reg cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);

endmodule


always @(posedge clk or negedge rst) begin
    if (~rst) begin
        sum <= 8'b0;
        cout <= 1'b0;
    end else begin
        sum <= a + b + cin;
        cout <= sum[7];
    end
end

endmodule
