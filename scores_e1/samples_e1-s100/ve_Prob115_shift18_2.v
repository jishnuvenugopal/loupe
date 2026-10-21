
module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q,
    output reg [63:0] q_prev
);

reg [63:0] shift_reg;
reg [1:0] shift_dir;
reg [1:0] shift_amount;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        shift_reg <= 64'b0;
        shift_dir <= 2'b00;
        shift_amount <= 2'b00;
        q <= 64'b0;
        q_prev <= 64'b0;
    end else begin
        if (load) begin
            shift_reg <= data;
            shift_dir <= 2'b00;
            shift_amount <= 2'b00;
            q_prev <= shift_reg;
        end else if (ena) begin
            case (amount)
                2'b00: begin
                    shift_dir <= 2'b00;
                    shift_amount <= 2'b01;
                    shift_reg <= {shift_reg[63:0], shift_reg[62:0]};
                end
                2'b01: begin
                    shift_dir <= 2'b00;
                    shift_amount <= 2'b10;
                    shift_reg <= {shift_reg[63:0], shift_reg[62:0]};
                end
                2'b10: begin
                    shift_dir <= 2'b01;
                    shift_amount <= 2'b00;
                    shift_reg <= {shift_reg[63:0], shift_reg[62:0]};
                end
                2'b11: begin
                    shift_dir <= 2'b01;
                    shift_amount <= 2'b01;
                    shift_reg <= {shift_reg[63:0], shift_reg[62:0]};
                end
            endcase
            q_prev <= shift_reg;
            q <= shift_reg;
        end
    end
end

endmodule
