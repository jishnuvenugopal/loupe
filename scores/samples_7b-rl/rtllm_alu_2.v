
module alu (
    input [31:0] a, b,
    input [5:0] aluc,
    output [31:0] r,
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
    reg carry_reg, overflow_reg, flag_reg;
    reg [32:0] sum, diff;

    
    assign r = res;
    assign zero = (res == 32'd0);
    assign carry = carry_reg;
    assign negative = res[31];
    assign overflow = overflow_reg;
    assign flag = flag_reg;

    always @* begin
        
        res = 32'd0;
        carry_reg = 1'b0;
        overflow_reg = 1'b0;
        flag_reg = 1'bz;

        case (aluc)
            ADD: begin
                sum = {1'b0, a} + {1'b0, b};
                res = sum[31:0];
                carry_reg = sum[32];
                overflow_reg = ( (a[31] == b[31]) && (res[31] != a[31]) );
            end
            ADDU: begin
                sum = {1'b0, a} + {1'b0, b};
                res = sum[31:0];
                carry_reg = sum[32];
                overflow_reg = 1'b0;
            end
            SUB: begin
                diff = {1'b0, a} - {1'b0, b};
                res = diff[31:0];
                carry_reg = ~diff[32];
                overflow_reg = ( (a[31] != b[31]) && (res[31] != a[31]) );
            end
            SUBU: begin
                res = a - b;
                carry_reg = (a >= b);
                overflow_reg = 1'b0;
            end
            AND: res = a & b;
            OR: res = a | b;
            XOR: res = a ^ b;
            NOR: res = ~(a | b);
            SLT: begin
                res = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
                flag_reg = res[0];
            end
            SLTU: begin
                res = (a < b) ? 32'd1 : 32'd0;
                flag_reg = res[0];
            end
            SLL: res = b << a[4:0];
            SRL: res = b >> a[4:0];
            SRA: res = $signed(b) >>> a[4:0];
            SLLV: res = b << a[4:0];
            SRLV: res = b >> a[4:0];
            SRAV: res = $signed(b) >>> a[4:0];
            LUI: res = { a[15:0], 16'b0 };
            default: res = 32'bz;
        endcase
    end

endmodule
