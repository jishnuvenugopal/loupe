
module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

    reg [63:0] shift_register;
    reg [1:0] shift_counter;

    always @(posedge clk) begin
        if (load) begin
            shift_register <= data;
            shift_counter <= 2'b00;
 
        end else if (ena) begin
            case (amount)
                2'b00: shift_register <= {shift_register[62:0], shift_register[63]};
                2'b01: shift_register <= {shift_register[60:0], shift_register[63]};
                2'b10: shift_register <= {shift_register[59:0], shift_register[63]};
                2'b11: shift_register <= {shift_register[57:0], shift_register[63]};
            endcase
            shift_counter <= shift_counter + 1'b1;
        end else begin
            shift_counter <= shift_counter;
        end
    end

    assign q = shift_register;

endmodule
