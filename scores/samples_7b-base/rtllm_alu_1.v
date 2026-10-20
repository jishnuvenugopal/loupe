
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

    reg [31:0] res;
    reg [4:0] shift_amt;

    always @(*) begin
        res = 32'b0;
        zero = 1'b0;
        carry = 1'b0;
        negative = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;

        case (aluc)
            ADD: begin
                res = a + b;
                carry = (a[31] & b[31] & ~res[31]) | (~a[31] & res[31] & b[31]);
                negative = res[31];
                overflow = (a[31] & b[31] & ~res[31]) | (~a[31] & res[31] & b[31]);
            end
            ADDU: begin
                res = a + b;
                carry = (a[31] & b[31] & ~res[31]) | (~a[31] & res[31] & b[31]);
            end
            SUB: begin
                res = a - b;
                carry = (a[31] & ~b[31] & ~res[31]) | (~a[31] & b[31] & res[31]);
                negative = res[31];
                overflow = (a[31] & ~b[31] & ~res[31]) | (~a[31] & b[31] & res[31]);
            end
            SUBU: begin
                res = a - b;
                carry = (a[31] & ~b[31] & ~res[31]) | (~a[31] & b[31] & res[31]);
            end
            AND: begin
                res = a & b;
            end
            OR: begin
                res = a | b;
            end
            XOR: begin
                res = a ^ b;
            end
            NOR: begin
                res = ~(a | b);
            end
            SLT: begin
                res = {31'b0, a[31] < b[31]};
                flag = 1'b1;
            end
            SLTU: begin
                res = {31'b0, a < b};
                flag = 1'b1;
            end
            SLL: begin
                shift_amt = aluc[4:0];
                res = {a << shift_amt, {shift_amt{1'b0}}};
                carry = a[31] & shift_amt[4];
            end
            SRL: begin
                shift_amt = aluc[4:0];
                res = {a >> shift_amt, {shift_amt{1'b0}}};
            end
            SRA: begin
                shift_amt = aluc[4:0];
                res = {a[31] << (31 - shift_amt), a >> shift_amt};
                carry = a[31] & shift_amt[4];
            end
            SLLV: begin
                shift_amt = a[4:0];
                res = {a << shift_amt, {shift_amt{1'b0}}};
                carry = a[31] & shift_amt[4];
            end
            SRLV: begin
                shift_amt = a[4:0];
                res = {a >> shift_amt, {shift_amt{1'b0}}};
            end
            SRAV: begin
                shift_amt = a[4:0];
                res = {a[31] << (31 - shift_amt), a >> shift_amt};
                carry = a[31] & shift_amt[4];
            end
            LUI: begin
                res = {a[15:0], 16'b0};
            end
            default: begin
                res = 32'b0;
            end
        endcase

        if (res == 32'b0)
            zero = 1'b1;

        r = res;
    end

endmodule
