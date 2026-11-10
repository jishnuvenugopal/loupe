
module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire cin,
    output reg [7:0] sum,
    output reg cout
);

    
    always @(*) begin
        sum[0] = a[0] ^ b[0] ^ cin;
        cout[0] = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);
    end

    
    assign sum[1] = a[1] ^ b[1] ^ cout[0];
    assign cout[1] = (a[1] & b[1]) | (a[1] & cout[0]) | (b[1] & cout[0]);

    assign sum[2] = a[2] ^ b[2] ^ cout[1];
    assign cout[2] = (a[2] & b[2]) | (a[2] & cout[1]) | (b[2] & cout[1]);

    assign sum[3] = a[3] ^ b[3] ^ cout[2];
    assign cout[3] = (a[3] & b[3]) | (a[3] & cout[2]) | (b[3] & cout[2]);

    assign sum[4] = a[4] ^ b[4] ^ cout[3];
    assign cout[4] = (a[4] & b[4]) | (a[4] & cout[3]) | (b[4] & cout[3]);

    assign sum[5] = a[5] ^ b[5] ^ cout[4];
    assign cout[5] = (a[5] & b[5]) | (a[5] & cout[4]) | (b[5] & cout[4]);

    assign sum[6] = a[6] ^ b[6] ^ cout[5];
    assign cout[6] = (a[6] & b[6]) | (a[6] & cout[5]) | (b[6] & cout[5]);

    assign sum[7] = a[7] ^ b[7] ^ cout[6];

endmodule
