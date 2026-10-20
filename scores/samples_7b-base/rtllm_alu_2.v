
module alu (
    input  [31:0] a,
    input  [31:0] b,
    input  [5:0]  aluc,
    output [31:0] r,
    output        zero,
    output        carry,
    output        negative,
    output        overflow,
    output        flag
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
reg [4:0] shift_amount;

always @(*) begin
    res = 32'b0;
    carry = 1'b0;
    negative = 1'b0;
    overflow = 1'b0;
    flag = 1'bz;

    case (aluc)
        ADD: begin
            res = a + b;
            carry = (a[31] == b[31]) & (res[31] != a[31]);
            negative = res[31];
        end
        ADDU: res = a + b;
        SUB: begin
            res = a - b;
            carry = (a[31] != b[31]) & (res[31] != a[31]);
            negative = res[31];
        end
        SUBU: res = a - b;
        AND: res = a & b;
        OR: res = a | b;
        XOR: res = a ^ b;
        NOR: res = ~(a | b);
        SLT: begin
            res = $signed(a) < $signed(b);
            flag = res;
        end
        SLTU: begin
            res = a < b;
            flag = res;
        end
        SLL: begin
            shift_amount = b[4:0];
            res = a << shift_amount;
        end
        SRL: begin
            shift_amount = b[4:0];
            res = a >> shift_amount;
        end
        SRA: begin
            shift_amount = b[4:0];
            res = {1'b0, a[31:1]} >> shift_amount;
        end
        SLLV: begin
            shift_amount = a[4:0];
            res = b << shift_amount;
        end
        SRLV: begin
            shift_amount = a[4:0];
            res = b >> shift_amount;
        end
        SRAV: begin
            shift_amount = a[4:0];
            res = {1'b0, b[31:1]} >> shift_amount;
        end
        LUI: res = {a[15:0], 16'b0};
        default: res = 32'b0;
    endcase

    zero = (res == 32'b0) ? 1'b1 : 1'b0;
    negative = res[31];
    overflow = (aluc == SLT || aluc == SLTU) && (res[31] != a[31] && res[31] != b[31]);
end

assign r = res;

endmodule
