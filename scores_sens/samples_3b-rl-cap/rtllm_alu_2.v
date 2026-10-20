
module alu (
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag
);

    
    reg [31:0] res;
    wire [31:0] a_signed, b_signed;
    wire [31:0] a_shift, b_shift;
    wire [4:0] shift_amount;

    
    assign a_signed = {1'b0, a[31:0]};
    assign b_signed = {1'b0, b[31:0]};

    
    assign shift_amount = a[4:0];

    
    assign a_shift = {16'b0, a[15:0]};

    
    always @(*) begin
        case (aluc)
            ADD: res = a + b;
            ADDU: res = a + b;
            SUB: res = a - b;
            SUBU: res = a - b;
            AND: res = a & b;
            OR: res = a | b;
            XOR: res = a ^ b;
            NOR: res = ~(a | b);
            SLT: res = (a_signed < b_signed) ? 32'b1 : 32'b0;
            SLTU: res = (a < b) ? 32'b1 : 32'b0;
            SLL: res = a << shift_amount;
            SRL: res = a >> shift_amount;
            SRA: res = a >>> shift_amount;
            SLLV: res = a << a[4:0];
            SRLV: res = a >> a[4:0];
            SRAV: res = a >>> a[4:0];
            LUI: res = a_shift;
            default: res = 32'b0;
        endcase
    end

    
    assign r = res[31:0];
    assign zero = (res == 32'b0);
    assign carry = (aluc == ADD || aluc == ADDU) ? res[31] : 1'b0;
    assign negative = (res[31] != 0);
    assign overflow = (aluc == ADD || aluc == ADDU) ? ((a[31] ^ b[31]) ^ res[31]) : 1'b0;
    assign flag = (aluc == SLT || aluc == SLTU) ? 1'b1 : 1'bz;

endmodule
