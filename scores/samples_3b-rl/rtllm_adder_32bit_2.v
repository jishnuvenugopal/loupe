
module adder_32bit (
    input  wire [31:1] A,
    input  wire [31:1] B,
    output reg  [31:1] S,
    output reg        C32
);

    
    module cla16 (
        input  wire [15:0] A,
        input  wire [15:0] B,
        input  wire        cin,
        output reg [15:0] sum,
        output reg        cout
    );

        reg [15:0] carry_in;
        reg [15:0] carry_out;

        
        genvar i;
        generate
            for (i = 0;
 i < 16;
 i = i + 1) begin : bit_adders
                
                assign sum[i] = A[i] ^ B[i] ^ carry_in[i];

                
                assign carry_out[i] = (A[i] & B[i]) | (A[i] & carry_in[i]) | (B[i] & carry_in[i]);
            end
        endgenerate

        
        assign carry_in[16] = carry_in[15] = 0;
        assign carry_in[15:0] = carry_out[15:0];

        
        assign cout = carry_out[15];

    endmodule

    
    wire [15:0] A16, B16;
    wire [15:0] sum16, sum26;
    wire        cout16, cout26;

    assign A16 = A[15:0];
    assign B16 = B[15:0];
    assign sum16 = sum[15:0];
    assign sum26 = sum[31:16];

    cla16 ucla16 (
        .A    (A16),
        .B    (B16),
        .cin  (1'b0),
        .sum  (sum16),
        .cout (cout16)
    );

    cla16 ucla26 (
        .A    (A[31:16]),
        .B    (B[31:16]),
        .cin  (cout16),
        .sum  (sum26),
        .cout (cout26)
    );

    
    assign S[15:0] = sum16;
    assign S[31:16] = sum26;
    assign C32 = cout26;

endmodule
