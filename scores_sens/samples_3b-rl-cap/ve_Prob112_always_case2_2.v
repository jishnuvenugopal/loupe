
module TopModule(
    input [3:0] in,
    output reg [1:0] pos
);

    reg [1:0] temp_pos;

    always @(*) begin
        if (in[3] == 1'b1) begin
            temp_pos = 2'b11;
        end else if (in[2] == 1'b1) begin
            temp_pos = 2'b10;
        end else if (in[1] == 1'b1) begin
            temp_pos = 2'b01;
        end else if (in[0] == 1'b1) begin
            temp_pos = 2'b00;
        end else begin
            temp_pos = 2'b00;
        end
    end

    assign pos = temp_pos;

endmodule
