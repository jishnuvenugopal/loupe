
module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

    reg [63:0] shift_reg;
    reg [1:0] shift_dir;
    reg [7:0] shift_amount;

    always @(posedge clk or posedge load) begin
        if (load) begin
            shift_reg <= data;
            shift_dir <= 2'b00;
            shift_amount <= 8'b00000000;
        end else if (ena) begin
            case (amount)
                2'b00: shift_dir <= 2'b00;
                    shift_amount <= 8'b00000000;
                2'b01: shift_dir <= 2'b00;
                    shift_amount <= 8'b11111111;
                2'b10: shift_dir <= 2'b01;
                    shift_amount <= 8'b00000000;
                2'b11: shift_dir <= 2'b01;
                    shift_amount <= 8'b11111111;
                default: shift_dir <= 2'b00;
                    shift_amount <= 8'b00000000;
            endcase
            case (shift_dir)
                2'b00: shift_reg <= {shift_reg[63:0], shift_reg[63:0]};
                2'b01: shift_reg <= {shift_reg[63:0], shift_reg[63:0]};
                2'b10: shift_reg <= {shift_reg[63:0], shift_reg[63:0]};
                2'b11: shift_reg <= {shift_reg[63:0], shift_reg[63:0]};
            endcase
        end
    end

    assign q = shift_reg;

endmodule
