
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

    
    wire [31:0] a_signed = a;
    wire [31:0] b_signed = b;

    
    assign r = res[31:0];

    
    always @(*) begin
        case (aluc)
            ADD, ADDU, SUB, SUBU, AND, OR, XOR, NOR, SLL, SRL, SRA, SLLV, SRLV, SRAV: flag = 'z;
 
            SLT, SLTU: flag = '1;
 
            default: flag = 'z;
 
        endcase
    end

    
    always @(*) begin
        zero = (r == 32'b0);
 
    end

    
    always @(*) begin
        carry = (r[31] != a_signed[31] ^ b_signed[31]);
 
    end

    
    always @(*) begin
        negative = (r[31] != 0);
 
    end

    
    always @(*) begin
        overflow = (r[31] != a_signed[31] ^ b_signed[31] ^ res[31]);
 
    end

    
    always @(*) begin
        case (aluc)
            ADD: res = a_signed + b_signed;
 
            ADDU: res = a + b;
 
            SUB: res = a_signed - b_signed;
 
            SUBU: res = a - b;
 
            AND: res = a & b;
 
            OR: res = a | b;
 
            XOR: res = a ^ b;
 
            NOR: res = ~(a | b);
 
            SLL: res = a_signed << (b[4:0]);
 
            SRL: res = a_signed >> (b[4:0]);
 
            SRA: res = a_signed >>> (b[4:0]);
 
            SLLV: res = a_signed << (a[4:0]);
 
            SRLV: res = a_signed >> (a[4:0]);
 
            SRAV: res = a_signed >>> (a[4:0]);
 
            LUI: res = {a[15:0], 16'b0};
 
            default: res = 'z;
 
        endcase
    end

    
    reg [31:0] res;

endmodule
