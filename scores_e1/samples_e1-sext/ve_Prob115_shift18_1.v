
module TopModule (
    input clk,
    input load,
    input ena,
    input amount,
    input [63:0] data,
    output reg [63:0] q
);

    reg [63:0] shift_register;
    reg [2:0] shift_position;
    reg [1:0] shift_direction;

    always @(posedge clk or posedge load) begin
        if (load) begin
            shift_register <= data;
            shift_position <= 0;
            shift_direction <= 0;
        end else if (ena) begin
            case (amount)
                2'b00: begin
                    shift_position <= shift_position + 1;
                    shift_direction <= 0;
                end
                2'b01: begin
                    shift_position <= shift_position + 8;
                    shift_direction <= 0;
                end
                2'b10: begin
                    shift_position <= shift_position + 1;
                    shift_direction <= 1;
                end
                2'b11: begin
                    shift_position <= shift_position + 8;
                    shift_direction <= 1;
                end
            endcase
        end
    end

    always @(posedge clk) begin
        if (shift_direction == 0) begin
            q <= {shift_register[63:shift_position], shift_register[shift_position-1:0]};
        end else begin
            q <= {shift_register[shift_position+1:0], shift_register[0:shift_position]};
        end
    end

endmodule
