
module alu (
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output zero,
    output reg carry,
    output negative,
    output reg overflow,
    output reg flag
);

    
    assign zero = (r == 32'b0);

    
    assign negative = r[31];

    
    reg [32:0] temp_add, temp_sub, temp_subu;

    always @* begin
        
        r = 32'bz;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'bz;

        case (aluc)
            
            6'b100000: begin
                temp_add = {1'b0, a} + {1'b0, b};
                r = temp_add[31:0];
                carry = temp_add[32];
                overflow = (a[31] == b[31]) && (r[31] != a[31]);
                flag = 1'bz;
            end
            
            6'b100001: begin
                temp_add = {1'b0, a} + {1'b0, b};
                r = temp_add[31:0];
                carry = temp_add[32];
                overflow = 1'b0;
                flag = 1'bz;
            end
            
            6'b100010: begin
                temp_sub = {1'b0, a} - {1'b0, b};
                r = temp_sub[31:0];
                carry = ~temp_sub[32];
                overflow = (a[31] != b[31]) && (r[31] != a[31]);
                flag = 1'bz;
            end
            
            6'b100011: begin
                temp_sub = {1'b0, a} - {1'b0, b};
                r = temp_sub[31:0];
                carry = ~temp_sub[32];
                overflow = 1'b0;
                flag = 1'bz;
            end
            
            6'b100100: begin
                r = a & b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            
            6'b100101: begin
                r = a | b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            
            6'b100110: begin
                r = a ^ b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            
            6'b100111: begin
                r = ~(a | b);
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            
            6'b101010: begin
                r = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
                carry = 1'b0;
                overflow = 1'b0;
                flag = r[0];
            end
            
            6'b101011: begin
                r = (a < b) ? 32'd1 : 32'd0;
                carry = 1'b0;
                overflow = 1'b0;
                flag = r[0];
            end
            
            6'b000000: begin
                r = a << b[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            
            6'b000010: begin
                r = a >> b[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            
            6'b000011: begin
                r = $signed(a) >>> b[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            
            6'b000100: begin
                r = b << a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            
            6'b000110: begin
                r = b >> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            
            6'b000111: begin
                r = $signed(b) >>> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            
            6'b001111: begin
                r = {a[15:0], 16'b0};
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            
            default: begin
                r = 32'bz;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
        endcase
    end

endmodule
