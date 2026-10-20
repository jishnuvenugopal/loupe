
module alu (
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output flag
);
    
    parameter ADD  = 6'b100000;
    parameter ADDU = 6'b100001;
    parameter SUB  = 6'b100010;
    parameter SUBU = 6'b100011;
    parameter AND  = 6'b100100;
    parameter OR   = 6'b100101;
    parameter XOR  = 6'b100110;
    parameter NOR  = 6'b100111;
    parameter SLT  = 6'b101010;
    parameter SLTU = 6'b101011;
    parameter SLL  = 6'b000000;
    parameter SRL  = 6'b000010;
    parameter SRA  = 6'b000011;
    parameter SLLV = 6'b000100;
    parameter SRLV = 6'b000110;
    parameter SRAV = 6'b000111;
    parameter LUI  = 6'b001111;

    reg [31:0] res;
    reg c_flag, o_flag;
    reg slt_flag;

    assign zero = (res == 32'd0);
    assign negative = res[31];
    assign carry = c_flag;
    assign overflow = o_flag;
    assign flag = ((aluc == SLT) || (aluc == SLTU)) ? slt_flag : 1'bz;

    always @* begin
        res = 32'd0;
        c_flag = 0;
        o_flag = 0;
        slt_flag = 0;

        case (aluc)
            ADD: begin
                {c_flag, res} = {1'b0, a} + {1'b0, b};
                o_flag = ( (a[31] == b[31]) && (res[31] != a[31]) );
            end
            ADDU: begin
                res = a + b;
                c_flag = (res > a);
            end
            SUB: begin
                {c_flag, res} = {1'b0, a} - {1'b0, b};
                c_flag = ~c_flag;
                o_flag = ( (a[31] != b[31]) && (res[31] != a[31]) );
            end
            SUBU: begin
                res = a - b;
                c_flag = (a >= b);
            end
            AND: res = a & b;
            OR:  res = a | b;
            XOR: res = a ^ b;
            NOR: res = ~(a | b);
            SLT: begin
                slt_flag = ($signed(a) < $signed(b)) ? 1'b1 : 1'b0;
                res = slt_flag;
            end
            SLTU: begin
                slt_flag = (a < b) ? 1'b1 : 1'b0;
                res = slt_flag;
            end
            SLL:  res = b << a[4:0];
            SRL:  res = b >> a[4:0];
            SRA:  res = $signed(b) >>> a[4:0];
            SLLV: res = b << a[4:0];
            SRLV: res = b >> a[4:0];
            SRAV: res = $signed(b) >>> a[4:0];
            LUI:  res = {a[15:0], 16'b0};
            default: res = 32'bz;
        endcase
    end

    always @* begin
        r = res;
    end
endmodule
