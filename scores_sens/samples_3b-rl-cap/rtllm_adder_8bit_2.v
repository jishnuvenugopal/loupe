
module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output reg [7:0] sum,
    output reg cout
);

    
    wire [7:0] carry_out;

    
    always @(*) begin
        sum[0] = a[0] ^ b[0] ^ cin;
        carry_out[0] = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);
    end

    always @(*) begin
        sum[1] = a[1] ^ b[1] ^ carry_out[0];
        carry_out[1] = (a[1] & b[1]) | (a[1] & carry_out[0]) | (b[1] & carry_out[0]);
    end

    always @(*) begin
        sum[2] = a[2] ^ b[2] ^ carry_out[1];
        carry_out[2] = (a[2] & b[2]) | (a[2] & carry_out[1]) | (b[2] & carry_out[1]);
    end

    always @(*) begin
        sum[3] = a[3] ^ b[3] ^ carry_out[2];
        carry_out[3] = (a[3] & b[3]) | (a[3] & carry_out[2]) | (b[3] & carry_out[2]);
    end

    always @(*) begin
        sum[4] = a[4] ^ b[4] ^ carry_out[3];
        carry_out[4] = (a[4] & b[4]) | (a[4] & carry_out[3]) | (b[4] & carry_out[3]);
    end

    always @(*) begin
        sum[5] = a[5] ^ b[5] ^ carry_out[4];
        carry_out[5] = (a[5] & b[5]) | (a[5] & carry_out[4]) | (b[5] & carry_out[4]);
    end

    always @(*) begin
        sum[6] = a[6] ^ b[6] ^ carry_out[5];
        carry_out[6] = (a[6] & b[6]) | (a[6] & carry_out[5]) | (b[6] & carry_out[5]);
    end

    always @(*) begin
        sum[7] = a[7] ^ b[7] ^ carry_out[6];
        carry_out[7] = (a[7] & b[7]) | (a[7] & carry_out[6]) | (b[7] & carry_out[6]);
    end

    
    assign cout = carry_out[7];

endmodule
