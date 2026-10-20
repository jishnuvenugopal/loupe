
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

reg [32:0] res;


wire [31:0] add_res = a + b;
wire [31:0] sub_res = a - b;
wire [32:0] addu_sum = {1'b0, a} + {1'b0, b};
wire [32:0] subu_diff = {1'b0, a} - {1'b0, b};
wire slt_res = ($signed(a) < $signed(b)) ? 1'b1 : 1'b0;
wire sltu_res = (a < b) ? 1'b1 : 1'b0;


assign zero = (res[31:0] == 32'b0);


assign negative = res[31];


assign flag = (aluc == SLT) ? slt_res :
              (aluc == SLTU) ? sltu_res :
              1'bz;


assign overflow = (aluc == ADD) ? (a[31] == b[31] && res[31] != a[31]) :
                  (aluc == SUB) ? (a[31] != b[31] && res[31] != a[31]) :
                  1'b0;


assign carry = (aluc == ADDU) ? addu_sum[32] :
               (aluc == SUBU) ? subu_diff[32] :
               1'b0;


wire [4:0] shift_amount_sll = a[4:0];
wire [4:0] shift_amount_sllv = a[4:0];


always @(*) begin
    case (aluc)
        ADD:  res = {1'b0, add_res};
        ADDU: res = addu_sum;
        SUB:  res = {1'b0, sub_res};
        SUBU: res = subu_diff;
        AND:  res = {1'b0, a & b};
        OR:   res = {1'b0, a | b};
        XOR:  res = {1'b0, a ^ b};
        NOR:  res = {1'b0, ~(a | b)};
        SLT:  res = {31'b0, slt_res};
        SLTU: res = {31'b0, sltu_res};
        SLL:  res = {1'b0, a << shift_amount_sll};
        SRL:  res = {1'b0, a >> shift_amount_sll};
        SRA:  res = {1'b0, $signed(a) >>> shift_amount_sll};
        SLLV: res = {1'b0, b << shift_amount_sllv};
        SRLV: res = {1'b0, b >> shift_amount_sllv};
        SRAV: res = {1'b0, $signed(b) >>> shift_amount_sllv};
        LUI:  res = {16'b0, a[15:0], 16'b0};
        default: res = 33'bz;
    endcase
end

assign r = res[31:0];

endmodule
