
module TopModule (
    input  [7:0] in,
    output [2:0] pos
);

    
    reg [2:0] state;

    
    function [2:0] find_first_high_bit(input [7:0] data);
        for (int i = 0;
 i < 8;
 i++) begin
            if (data[i] == 1'b1) begin
                find_first_high_bit = i;
                break;
            end
        end
    endfunction

    
    always @(posedge clk) begin
        if (rst) begin
            state <= 3'b000;
        end else begin
            if (in[0] == 1'b1) begin
                state <= 3'b001;
            end else if (in[1] == 1'b1) begin
                state <= 3'b010;
            end else if (in[2] == 1'b1) begin
                state <= 3'b011;
            end else if (in[3] == 1'b1) begin
                state <= 3'b100;
            end else if (in[4] == 1'b1) begin
                state <= 3'b101;
            end else if (in[5] == 1'b1) begin
                state <= 3'b110;
            end else if (in[6] == 1'b1) begin
                state <= 3'b111;
            end else begin
                state <= state;
            end
        end
    end

    
    assign pos = state;

endmodule
