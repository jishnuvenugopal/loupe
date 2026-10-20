
module TopModule (
    input  clk,
    input  enable,
    input  S,
    input  A,
    input  B,
    input  C,
    output Z
);

    
    reg [7:0] shift_register;

    
    reg [2:0] abc;
    assign abc = {A, B, C};

    
    always @(posedge clk) begin
        if (enable) begin
            shift_register <= {S, shift_register[7:1]};
        end
    end

    
    always @(*) begin
        case (abc)
            3'b000: Z = shift_register[0];
            3'b001: Z = shift_register[1];
            3'b010: Z = shift_register[2];
            3'b011: Z = shift_register[3];
            3'b100: Z = shift_register[4];
            3'b101: Z = shift_register[5];
            3'b110: Z = shift_register[6];
            3'b111: Z = shift_register[7];
            default: Z = 1'b0;
 
        endcase
    end

endmodule
