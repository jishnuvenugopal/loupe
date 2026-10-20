
module float_multi (
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] z
);

    reg [2:0] counter;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [9:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [49:0] product;
    reg guard_bit, round_bit, sticky;

    wire [31:0] result;

    
    parameter IDLE = 3'b000,
             FETCH = 3'b001,
             PROCESS = 3'b010,
             OUTPUT = 3'b011;

    reg [1:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'b000;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (counter == 3'b000) begin
                        
                        a_mantissa <= a[22:0];
                        a_exponent <= a[30:23];
                        a_sign <= a[31];
                        b_mantissa <= b[22:0];
                        b_exponent <= b[30:23];
                        b_sign <= b[31];
                        counter <= 3'b001;
                    end else begin
                        state <= FETCH;
                    end
                end
                FETCH: begin
                    
                    
                    if (a_exponent == 9'h1FF && a_mantissa != 23'b0) begin
                        z <= 32'h7FC00000;
 
                    end else if (a_exponent == 9'h1FF) begin
                        z <= 32'h7F800000;
 
                    end else if (b_exponent == 9'h1FF && b_mantissa != 23'b0) begin
                        z <= 32'h7FC00000;
 
                    end else if (b_exponent == 9'h1FF) begin
                        z <= 32'h7F800000;
 
                    end else begin
                        
                        product <= a_mantissa[22] ? 48'h0 : 48'h000000000000;
                        product[46:23] <= (a_mantissa * b_mantissa);
                        
                        z_sign <= a_sign ^ b_sign;
                        z_exponent <= a_exponent + b_exponent;
                        
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky <= product[20:0] != 21'b0;
                        z_mantissa <= (product[46:23] + (guard_bit && (round_bit || sticky)));
                        if (z_mantissa > 24'h000FFFFF) begin
                            z_exponent <= z_exponent + 1;
                            z_mantissa <= z_mantissa[23];
                        end
                        
                        result <= {z_sign, z_exponent, z_mantissa};
                        
                        if (z_exponent == 10'h200) begin
                            result <= 32'h7F800000;
 
                        end else if (z_exponent == 10'h000 && z_mantissa != 24'b0) begin
                            result <= 32'h00800000;
 
                        end
                        z <= result;
                    end
                    counter <= 3'b000;
                    state <= IDLE;
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
