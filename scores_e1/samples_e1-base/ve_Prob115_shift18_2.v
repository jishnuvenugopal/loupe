
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

    always @(posedge clk or posedge load or posedge ena) begin
        if (load) begin
            shift_register <= data;
            shift_counter <= 2'b00;
        end else if (ena) begin
            case (amount)
                2'b00: shift_register <= {shift_register[62:0], shift_register[63]};
                2'b01: shift_register <= {shift_register[63:0], shift_register[62:0]};
                2'b10: shift_register <= {shift_register[63:1], shift_register[62:0]};
                2'b11: shift_register <= {shift_register[62:7], shift_register[63:0]};
            endcase
            shift_counter <= shift_counter + 1;
        end
    end

    assign q = shift_register;

endmodule
