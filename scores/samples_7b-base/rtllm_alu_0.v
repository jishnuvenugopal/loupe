
module alu (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [5:0] aluc,
    output reg [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag
);

    parameter ADD = 6'b100000;
    parameter ADDU = 6'b100001;
    parameter SUB = 6'b100010;
    parameter SUBU = 6'b100011;
    parameter AND = 6'b100100;
    parameter OR = 6'b100101;
    parameter XOR = 6'b100110;
    parameter NOR = 6'b100111;
    parameter SLT = 6'b101010;
    parameter SLTU = 6'b101011;
    parameter SLL = 6'b000000;
    parameter SRL = 6'b000010;
    parameter SRA = 6'b000011;
    parameter SLLV = 6'b000100;
    parameter SRLV = 6'b000110;
    parameter SRAV = 6'b000111;
    parameter LUI = 6'b001111;

    wire signed [31:0] a_signed = $signed(a);
    wire signed [31:0] b_signed = $signed(b);
    wire [31:0] res;

    always @(*) begin
        zero = 1'b0;
        carry = 1'b0;
        negative = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;

        case (aluc)
            ADD:  res = a_signed + b_signed;
            ADDU: res = a + b;
            SUB:  res = a_signed - b_signed;
            SUBU: res = a - b;
            AND:  res = a & b;
            OR:   res = a | b;
            XOR:  res = a ^ b;
            NOR:  res = ~(a | b);
            SLT:  res = (a_signed < b_signed) ? 32'b1 : 32'b0;
            SLTU: res = (a < b) ? 32'b1 : 32'b0;
            SLL:  res = {a << b[4:0], 6'b0};
            SRL:  res = {6'b0, a >> b[4:0]};
            SRA:  res = {a[31], a[31] << b[4:0]};
            SLLV: res = {a << (b[4:0] & 6'b11111), 6'b0};
            SRLV: res = {6'b0, a >> (b[4:0] & 6'b11111)};
            SRAV: res = {a[31], a[31] << (b[4:0] & 6'b11111)};
            LUI:  res = {b[15:0], 16'b0};
            default: res = 32'bz;
        endcase

        r = res;
        zero = (res == 32'b0);
        negative = (res[31] == 1'b1);
        overflow = (aluc == SLT || aluc == SLTU) && (a_signed[31] == b_signed[31]) && (res[31] != a_signed[31]);
        flag = (aluc == SLT || aluc == SLTU) ? 1'b1 : 1'b0;
    end

endmodule
