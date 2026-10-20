
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
    reg [4:0] shift_amount;

    
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

    always @(*) begin
        
        res = 32'dz;

        
        zero = 1'b0;

        
        carry = 1'b0;

        
        negative = 1'b0;

        
        overflow = 1'b0;

        
        flag = 1'b0;

        
        shift_amount = a[4:0];

        
        case (aluc)
            ADD: res = a + b;
            ADDU: res = a + b;
            SUB: res = a - b;
            SUBU: res = a - b;
            AND: res = a & b;
            OR: res = a | b;
            XOR: res = a ^ b;
            NOR: res = ~(a | b);
            SLT: res = (a < b) ? 1'b1 : 1'b0;
            SLTU: res = (a < b) ? 1'b1 : 1'b0;
            SLL: res = a << shift_amount;
            SRL: res = a >> shift_amount;
            SRA: res = a >>> shift_amount;
            SLLV: res = a << (a[4:0]);
            SRLV: res = a >> (a[4:0]);
            SRAV: res = a >>> (a[4:0]);
            LUI: res = {a[15:0], 16'd0};

            default: res = 32'dz;
        endcase

        
        if (res == 32'd0)
            zero = 1'b1;

        
        
        
        
        if (aluc == ADD || aluc == ADDU) begin
            carry = (a[31] != b[31]) && (res[31] == b[31]);
        end else if (aluc == SUB || aluc == SUBU) begin
            carry = (a[31] != b[31]) && (res[31] == a[31]);
        end

        
        
        negative = res[31];

        
        
        if (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) begin
            overflow = (a[31] == b[31]) && (res[31] != a[31]);
        end

        
        if (aluc == SLT || aluc == SLTU)
            flag = 1'b1;
        else
            flag = 1'bz;
    end

    
    assign r = res[31:0];

endmodule
