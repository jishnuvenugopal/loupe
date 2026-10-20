
module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z = 0
);

    reg [2:0] counter;
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_man, b_man;
    reg [47:0] product_man;
    reg [9:0] sum_exp;

    reg [22:0] mantissa_out;
    reg guard, round, sticky;
    reg z_sign;
    reg [7:0] z_exp;
    reg [22:0] z_man;

    always @(posedge clk) begin
        if (rst) begin
            counter <= 0;
            z <= 0;
        end else begin
            case (counter)
                0: begin
                    
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    a_man <= a[22:0];
                    b_man <= b[22:0];
                    counter <= 1;
                end

                1: begin
                    
                    if ((a_exp == 8'hff && a_man != 0) || 
                        (b_exp == 8'hff && b_man != 0)) begin
                        
                        z <= {1'b0, 8'hff, 22'h1};
 
                    end else if (a_exp == 8'hff || b_exp == 8'hff) begin
                        
                        if (a_exp == 8'hff && b_exp == 8'hff && 
                            (a_man != 0 || b_man != 0)) begin
                            z <= {1'b0, 8'hff, 22'h0};
 
                        end else begin
                            z <= {(a_exp == 8'hff) ? a : b};
 
                        end
                    end else begin
                        
                        sum_exp <= a_exp + b_exp - 9'd127;
                        product_man <= {1'b1, a_man} * {1'b1, b_man};
                        counter <= 2;
                    end
                end

                2: begin
                    
                    if (product_man[47]) begin
                        mantissa_out <= product_man[46:24];
                        sum_exp <= sum_exp + 1;
                    end else begin
                        mantissa_out <= product_man[45:23];
                    end

                    
                    guard <= product_man[22];
                    round <= product_man[21];
                    sticky <= |product_man[20:0];
                    counter <= 3;
                end

                3: begin
                    
                    if (guard && (round | sticky | mantissa_out[0])) begin
                        mantissa_out <= mantissa_out + 1;
                    end
                    
                    if (mantissa_out[22] && (sum_exp >= 9'h1FF)) begin
                        z_exp <= 8'hff;
                        z_man <= 0;
                    end else if (sum_exp[8] || sum_exp == 0) begin
                        z_exp <= 0;
                        z_man <= 0;
                    end else begin
                        z_exp <= sum_exp[7:0];
                        z_man <= mantissa_out;
                    end
                    z_sign <= a_sign ^ b_sign;
                    z <= {z_sign, z_exp, z_man};
                    counter <= 0;
                end
            endcase
        end
    end

endmodule
