
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

    
    wire [31:0] res;
    wire [31:0] a_signed, b_signed;
    wire [31:0] shift_amount;
    wire [31:0] lui_result;

    
    assign a_signed = {1'b0, a};
    assign b_signed = {1'b0, b};

    
    assign lui_result = {a[15:0], 16'b0};

    
    assign shift_amount = (aluc[4:0] == 5'b00000) ? a[4:0] : 5'b00000;

    always @(*) begin
        case (aluc)
            
            6'b100000: res = a + b;
            6'b100001: res = a + b;
            
            6'b100010: res = a - b;
            6'b100011: res = a - b;
            
            6'b100100: res = a & b;
            
            6'b100101: res = a | b;
            
            6'b100110: res = a ^ b;
            
            6'b100111: res = ~(a | b);
            
            6'b101010: res = (a_signed < b_signed) ? 32'b1 : 32'b0;
            
            6'b101011: res = (a < b) ? 32'b1 : 32'b0;
            
            6'b000000: res = a << shift_amount;
            
            6'b000010: res = a >> shift_amount;
            
            6'b000011: res = a_signed >> shift_amount;
            
            6'b000100: res = a << a[4:0];
            
            6'b000110: res = a >> a[4:0];
            
            6'b000111: res = a_signed >> a[4:0];
            
            6'b001111: res = lui_result;
            default: res = 32'b0;
        endcase
    end

    
    assign r = res[31:0];

    
    assign zero = (res == 32'b0) ? 1'b1 : 1'b0;

    
    
    assign carry = (res[31] ^ a[31] ^ b[31]) ? 1'b1 : 1'b0;

    
    
    assign negative = res[31];

    
    
    assign overflow = ((a_signed[31] == b_signed[31]) && (res[31] != a_signed[31])) ? 1'b1 : 1'b0;

    
    
    assign flag = (aluc == 6'b101010 || aluc == 6'b101011) ? 1'b1 : 1'b0;

endmodule
